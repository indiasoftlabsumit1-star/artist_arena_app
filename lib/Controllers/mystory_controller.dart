import 'dart:io';

import 'package:artist_arena_app/Service/apiService.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/storyModel.dart';
import '../Models/uploadModel.dart';

class MyStoryController extends GetxController {
  CameraController? cameraController;

  RxBool isCameraInitialized = false.obs;
  RxBool isFrontCamera = false.obs;
  RxBool isFlashOn = false.obs;
  RxBool isUploadingStory = false.obs;
final Apiservice apiService =Apiservice();
  Rxn<UploadFileModel> uploadedStory = Rxn<UploadFileModel>();
  RxList<AssetEntity> recentImages = <AssetEntity>[].obs;
  final Rxn<StoriesRowModel> storiesRow = Rxn<StoriesRowModel>();

  List<CameraDescription> cameras = [];


  @override
  void onInit() {
    super.onInit();

    initializeCamera();
    loadRecentImages();
  }

  // ---------------- CAMERA ----------------

  Future<void> initializeCamera() async {
    try {
      isCameraInitialized.value = false;

      cameras = await availableCameras();

      // print("Available cameras: ${cameras.length}");

      if (cameras.isEmpty) {
        // print("No camera found");
        return;
      }

      // for (var camera in cameras) {
      //   // print(
      //   //   "Camera: ${camera.name} | "
      //   //       "Lens: ${camera.lensDirection}",
      //   // );
      // }

      CameraDescription selectedCamera;


      if (isFrontCamera.value) {
        selectedCamera = cameras.firstWhere(
              (camera) =>
          camera.lensDirection ==
              CameraLensDirection.front,
          orElse: () => cameras.first,
        );
      } else {
        selectedCamera = cameras.firstWhere(
              (camera) =>
          camera.lensDirection ==
              CameraLensDirection.back,
          orElse: () => cameras.first,
        );
      }

      cameraController = CameraController(
        selectedCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await cameraController!.initialize();

      // print(
      //   "Camera initialized: "
      //       "${cameraController!.value.isInitialized}",
      // );

      if (cameraController!.value.isInitialized) {
        await cameraController!.setFlashMode(
          FlashMode.off,
        );

        isFlashOn.value = false;
        isCameraInitialized.value = true;

        // print("CAMERA PREVIEW READY");
      }
    }
    // on CameraException catch (e) {
      // print("CAMERA EXCEPTION");
      // print("Code: ${e.code}");
      // print("Description: ${e.description}");
    // }
    catch (e) {
      // print("CAMERA ERROR: $e");
    }
  }
  // ---------------- FRONT / BACK ----------------

  Future<void> switchCamera() async {
    if (cameras.length < 2) {
      return;
    }

    isCameraInitialized.value = false;

    final oldController = cameraController;
    cameraController = null;

    if (oldController != null) {
      await oldController.dispose();
    }

    isFrontCamera.value = !isFrontCamera.value;

    await initializeCamera();
  }

  // ---------------- FLASH ----------------

  Future<void> toggleFlash() async {
    if (cameraController == null ||
        !cameraController!.value.isInitialized) {
      return;
    }

    try {
      if (isFlashOn.value) {
        await cameraController!.setFlashMode(
          FlashMode.off,
        );

        isFlashOn.value = false;
      } else {
        await cameraController!.setFlashMode(
          FlashMode.torch,
        );

        isFlashOn.value = true;
      }
    } catch (e) {
      // print("Flash Error: $e");

    }
  }

  // ---------------- TAKE PHOTO ----------------

  Future<String?> takePhoto() async {
    if (cameraController == null ||
        !cameraController!.value.isInitialized) {
      return null;
    }

    try {
      final XFile photo =
      await cameraController!.takePicture();

      return photo.path;
    } catch (e) {
      // print("Take Photo Error: $e");
      return null;
    }
  }

  // ---------------- GALLERY ----------------
  Future<void> loadRecentImages() async {
    try {
      final PermissionState permission =
      await PhotoManager.requestPermissionExtend();

      if (!permission.hasAccess) {
        // print("Gallery permission not granted");
        return;
      }

      final FilterOptionGroup filter =
      FilterOptionGroup(
        orders: [
          OrderOption(
            type: OrderOptionType.createDate,
            asc: false,
          ),
        ],
      );

      final List<AssetPathEntity> albums =
      await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: true,
        filterOption: filter,
      );

      if (albums.isEmpty) {
        // print("No gallery album found");
        return;
      }

      final AssetPathEntity recentAlbum =
          albums.first;

      final List<AssetEntity> images =
      await recentAlbum.getAssetListPaged(
        page: 0,
        size: 30,
      );

      recentImages.assignAll(images);

      // print(
      //   "Recent images loaded: ${recentImages.length}",
      // );
    } catch (e) {
      // print("Gallery Error: $e");
    }
  }
  // ---------------- SELECT GALLERY IMAGE ----------------

  Future<String?> selectImage(AssetEntity image) async {
    try {
      final file = await image.file;

      return file?.path;
    } catch (e) {
      // print("Select Image Error: $e");
      return null;
    }
  }
  Future<bool> uploadStory(String filePath) async {
    if (isUploadingStory.value) {
      return false;
    }

    final file = File(filePath);

    if (!await file.exists()) {
      Get.snackbar(
        'Error',
        'Selected image file not found.',
      );
      return false;
    }

    try {
      isUploadingStory.value = true;

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        Get.snackbar(
          'Error',
          'Please login again.',
        );
        return false;
      }

      final response = await apiService.storyUpload(
        token: token,
        file: file,
      );

      if (response.success && response.data != null) {
        uploadedStory.value = response;

        Get.snackbar(
          'Success',
          response.message,
        );

        return true;
      } else {
        Get.snackbar(
          'Error',
          response.message.isNotEmpty
              ? response.message
              : 'Failed to upload story.',
        );

        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
      );

      return false;
    } finally {
      isUploadingStory.value = false;
    }
  }

  Future<bool> createStory({
    required String media,
  }) async {
    try {
      isUploadingStory.value = true;

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        throw Exception("Authentication token not found");
      }

      final response = await apiService.createStory(
        token: token,
        media: media,
      );

      if (response.status) {
        Get.snackbar("Success", response.message);
        return true;
      }

      Get.snackbar("Error", response.message);
      return false;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isUploadingStory.value = false;
    }
  }


  Future<void> fetchStories() async {
    try {
      isUploadingStory.value = true;

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        throw Exception("Authentication token not found");
      }

      final response = await apiService.getStories(
        token: token,
      );

      storiesRow.value = response;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isUploadingStory.value = false;
    }
  }


  @override
  void onClose() {
    final controller = cameraController;

    cameraController = null;
    isCameraInitialized.value = false;

    if (controller != null) {
      controller.dispose();
    }

    super.onClose();
  }



}