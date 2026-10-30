import 'dart:io';

import 'package:artist_arena_app/Models/myStoryModel.dart';
import 'package:artist_arena_app/Service/apiService.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/storyModel.dart';
import '../Models/storyViewModel.dart';
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

  RxList<AssetPathEntity> galleryAlbums =
      <AssetPathEntity>[].obs;

  Rxn<AssetPathEntity> selectedAlbum =
  Rxn<AssetPathEntity>();

  RxBool isLoadingGallery = false.obs;
  final Rxn<StoriesRowModel> storiesRow = Rxn<StoriesRowModel>();
  final Rxn<MyStoryModel> myStories=Rxn<MyStoryModel>();
  int currentGalleryPage = 0;
  final int galleryPageSize = 100;

  RxBool hasMoreGalleryMedia = true.obs;
  RxBool isLoadingMoreGalleryMedia = false.obs;

  List<CameraDescription> cameras = [];

  final Rxn<StoryViewModel> storyViewers = Rxn<StoryViewModel>();
  final RxBool isLoadingViewers = false.obs;
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
      isLoadingGallery.value = true;

      final PermissionState permission =
      await PhotoManager.requestPermissionExtend();

      if (!permission.hasAccess) {
        Get.snackbar(
          'Permission Required',
          'Allow gallery access to select story media.',
        );
        return;
      }

      final FilterOptionGroup filter = FilterOptionGroup(
        orders: [
          OrderOption(
            type: OrderOptionType.createDate,
            asc: false,
          ),
        ],
      );

      final List<AssetPathEntity> albums =
      await PhotoManager.getAssetPathList(
        type: RequestType.common,
        onlyAll: false,
        filterOption: filter,
      );

      galleryAlbums.assignAll(albums);

      if (albums.isEmpty) {
        recentImages.clear();
        selectedAlbum.value = null;
        return;
      }

      // Recent / All media album ko pehle select karo.
      final AssetPathEntity allMediaAlbum = albums.firstWhere(
            (album) => album.isAll,
        orElse: () => albums.first,
      );

      await selectGalleryAlbum(allMediaAlbum);
    } catch (e) {
      Get.snackbar(
        'Gallery Error',
        'Unable to load gallery albums.',
      );
    } finally {
      isLoadingGallery.value = false;
    }
  }

  Future<void> selectGalleryAlbum(AssetPathEntity album) async {
    try {
      isLoadingGallery.value = true;
      currentGalleryPage = 0;
      hasMoreGalleryMedia.value = true;

      selectedAlbum.value = album;
      recentImages.clear();

      final List<AssetEntity> media =
      await album.getAssetListPaged(
        page: currentGalleryPage,
        size: galleryPageSize,
      );

      recentImages.assignAll(media);
      currentGalleryPage++;

      hasMoreGalleryMedia.value = media.length == galleryPageSize;
    } catch (e) {
      Get.snackbar(
        'Gallery Error',
        'Unable to load selected album.',
      );
    } finally {
      isLoadingGallery.value = false;
    }
  }

  Future<void> loadMoreGalleryMedia() async {
    if (isLoadingGallery.value ||
        isLoadingMoreGalleryMedia.value ||
        !hasMoreGalleryMedia.value) {
      return;
    }

    final album = selectedAlbum.value;
    if (album == null) return;

    try {
      isLoadingMoreGalleryMedia.value = true;

      final List<AssetEntity> media =
      await album.getAssetListPaged(
        page: currentGalleryPage,
        size: galleryPageSize,
      );

      if (media.isNotEmpty) {
        recentImages.addAll(media);
        currentGalleryPage++;
      }

      hasMoreGalleryMedia.value = media.length == galleryPageSize;
    } catch (e) {
      Get.snackbar(
        'Gallery Error',
        'Unable to load more media.',
      );
    } finally {
      isLoadingMoreGalleryMedia.value = false;
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

  Future<void> myStory()async{


    try

        {
          isUploadingStory.value=true;
          final pref=await SharedPreferences.getInstance();
          final token=pref.getString('token');

          if(token==null||token.isEmpty){
            print('token not found');
            return;
          }
          final response=await apiService.myAStory(token);
          myStories.value=response;
        }catch(e){
      Get.snackbar('My Story', "$e");
    }finally{
      isUploadingStory.value=false;
    }
  }

  Future<void> storySeen(int storyId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'Please login again.');
        return;
      }

      final response = await apiService.storySeen(
        token: token,
        storyId: storyId,
      );

      if (response.isSeen) {
        final items = storiesRow.value?.data?.items;

        if (items == null) return;

        for (final item in items) {
          for (final story in item.stories) {
            if (story.id == response.storyId) {
              story.isSeen = true;
            }
          }

          item.hasUnseen =
              item.stories.any((story) => !story.isSeen);
        }

        storiesRow.refresh();
      }
    } catch (e) {
      Get.snackbar('Story Seen', e.toString());
    }
  }



  Future<void> fetchStoryViewers(int storyId) async {
    try {
      isLoadingViewers.value = true;

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      final response = await apiService.storyView(
        token: token,
        storyId: storyId,
      );

      storyViewers.value = response;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingViewers.value = false;
    }
  }
  Future<bool> deleteStory(int storyId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      await apiService.deleteStory(
        token: token,
        storyId: storyId,
      );

      // Refresh Home stories after successful deletion
      await fetchStories();

      storyViewers.value = null;

      Get.snackbar(
        'Success',
        'Story deleted successfully.',
      );

      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
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