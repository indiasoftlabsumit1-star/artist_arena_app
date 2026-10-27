import 'dart:io';

import 'package:artist_arena_app/Controllers/profile_controller.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

class MyStoryController extends GetxController {
  CameraController? cameraController;

  RxBool isCameraInitialized = false.obs;
  RxBool isFrontCamera = false.obs;
  RxBool isFlashOn = false.obs;

  RxList<AssetEntity> recentImages = <AssetEntity>[].obs;

  List<CameraDescription> cameras = [];

  final profileController=Get.find<ProfileController>();

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