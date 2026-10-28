import 'dart:math';
import 'dart:typed_data';

import 'package:artist_arena_app/Screens/upload_story.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sizer/sizer.dart';

import '../Controllers/mystory_controller.dart';

class MyStoryScreen extends StatefulWidget {
  MyStoryScreen({super.key});

  @override
  State<MyStoryScreen> createState() => _MyStoryScreenState();
}

class _MyStoryScreenState extends State<MyStoryScreen> {
  final controller = Get.find<MyStoryController>();
  bool isGalleryExpanded = false;


  Widget buildGalleryPanel() {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy > 8 && isGalleryExpanded) {
          setState(() => isGalleryExpanded = false);
        }
      },
      child: Container(
        color: Colors.black,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),

              // Gallery handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 16),

              // Gallery title
              const Text(
                'Gallery',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              // Album dropdown
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(() {
                  final albums = controller.galleryAlbums;
                  final selected = controller.selectedAlbum.value;

                  if (albums.isEmpty || selected == null) {
                    return const SizedBox.shrink();
                  }

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<AssetPathEntity>(
                      value: albums.any((album) => album.id == selected.id)
                          ? albums.firstWhere(
                            (album) => album.id == selected.id,
                      )
                          : null,
                      isExpanded: true,
                      dropdownColor: const Color(0xFF252525),
                      underline: const SizedBox.shrink(),
                      iconEnabledColor: Colors.white,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      items: albums.map((album) {
                        return DropdownMenuItem<AssetPathEntity>(
                          value: album,
                          child: Text(
                            album.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (album) {
                        if (album != null) {
                          controller.selectGalleryAlbum(album);
                        }
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: 12),

              // Media grid
              Expanded(
                child: Obx(() {
                  if (controller.isLoadingGallery.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  }

                  final media = controller.recentImages;

                  if (media.isEmpty) {
                    return const Center(
                      child: Text(
                        'No photos or videos found',
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }

                  return
                    NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification.metrics.pixels >=
                            notification.metrics.maxScrollExtent - 200) {
                          controller.loadMoreGalleryMedia();
                        }
                        return false;
                      },
                      child: GridView.builder(
                        padding: const EdgeInsets.all(4),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 3,
                          mainAxisSpacing: 3,
                        ),
                        itemCount: controller.recentImages.length,
                        itemBuilder: (context, index) {
                          final asset = controller.recentImages[index];

                          return GestureDetector(
                            onTap: () async {
                              final path = await controller.selectImage(asset);

                              if (path == null) {
                                Get.snackbar(
                                  'Error',
                                  'Unable to select this media.',
                                );
                                return;
                              }

                              final success = await controller.uploadStory(path);

                              if (!mounted) return;

                              if (success &&
                                  controller.uploadedStory.value?.data?.path != null) {
                                setState(() {
                                  isGalleryExpanded = false;
                                });

                                Get.to(
                                      () => UploadStory(
                                    imagePath: path,
                                    mediaPath:
                                    controller.uploadedStory.value!.data!.path,
                                  ),
                                );
                              }
                            },
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                FutureBuilder<Uint8List?>(
                                  future: asset.thumbnailDataWithSize(
                                    const ThumbnailSize(250, 250),
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.data == null) {
                                      return Container(color: Colors.white10);
                                    }

                                    if (snapshot.data == null || snapshot.data!.isEmpty) {
                                      return Container(
                                        color: Colors.white10,
                                        child: const Icon(
                                          Icons.broken_image,
                                          color: Colors.white54,
                                        ),
                                      );
                                    }

                                    return Image.memory(
                                      snapshot.data!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.white10,
                                          child: const Icon(
                                            Icons.broken_image,
                                            color: Colors.white54,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                                if (asset.type == AssetType.video)
                                  const Positioned(
                                    right: 4,
                                    bottom: 4,
                                    child: Icon(
                                      Icons.play_circle_fill,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    );

                }),
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        return Stack(
          fit: StackFit.expand,
          children: [
            // ================= CAMERA PREVIEW =================
            if (controller.isCameraInitialized.value &&
                controller.cameraController != null)
              Positioned.fill(
                child: CameraPreview(controller.cameraController!),
              )
            else
              const Positioned.fill(child: ColoredBox(color: Colors.black)),

            // ================= TOP LEFT BACK =================
            Positioned(
              top: 5.h,
              left: 2.w,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_back, color: Colors.white, size: 6.w),
                ),
              ),
            ),


            if (isGalleryExpanded)
              Positioned.fill(
                child: buildGalleryPanel(),
              ),

            // ================= BOTTOM CONTROLS =================

            // ================= BOTTOM CONTROLS =================
            Positioned(
              left: 0,
              right: 0,
              bottom: 2.h,
              child: Column(
                children: [
                  // ================= GALLERY THUMBNAILS =================
                  if (!isGalleryExpanded)
                    GestureDetector(

                      onVerticalDragUpdate: (details) {
                        if (details.delta.dy < -5) {
                          setState(() => isGalleryExpanded = true);
                        }
                      },

                      child: SizedBox(
                        height: 10.h,
                        child: Obx(() {
                          if (controller.recentImages.isEmpty) {
                            return const SizedBox();
                          }
                      
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            itemCount: controller.recentImages.length.clamp(0, 8),
                            itemBuilder: (context, index) {
                              final image = controller.recentImages[index];
                      
                              return GestureDetector(
                                onTap: () async {
                                  final path = await controller.selectImage(
                                    image,
                                  );
                      
                                  if (path == null) return;
                      
                                  final success = await controller.uploadStory(
                                    path,
                                  );
                      
                                  if (success &&
                                      controller
                                              .uploadedStory
                                              .value
                                              ?.data
                                              ?.path !=
                                          null) {
                                    Get.to(
                                          () => UploadStory(
                                        imagePath: path,
                                        mediaPath: controller.uploadedStory.value!.data!.path,
                                            isVideo: image.type == AssetType.video,                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  width: 15.w,
                                  margin: EdgeInsets.only(right: 1.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(1.w),
                                    border: Border.all(color: Colors.white),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(1.w),
                                    child: FutureBuilder<Uint8List?>(
                                      future: image.thumbnailDataWithSize(
                                        const ThumbnailSize(300, 300),
                                      ),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return const SizedBox();
                                        }
                      
                                        return Image.memory(
                                          snapshot.data!,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ),

                  if (!isGalleryExpanded) SizedBox(height: 2.h),

                  if (!isGalleryExpanded)
                    Builder(
                      builder: (context) {
                        final screenWidth = MediaQuery.of(context).size.width;

                        // Camera button responsive rahega
                        final double buttonSize = min(screenWidth * 0.18, 10.h);

                        return SizedBox(
                          height: buttonSize,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // ================= FLASH =================
                              Positioned(
                                left: 7.w,
                                top: 0,
                                bottom: 0,
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.toggleFlash();
                                    },
                                    child: Obx(
                                      () => Icon(
                                        controller.isFlashOn.value
                                            ? Icons.flash_on
                                            : Icons.flash_off,
                                        color: Colors.white,
                                        size: 5.w,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // ================= CAMERA BUTTON =================
                              Center(
                                child: GestureDetector(
                                  onTap: () async {
                                    final path = await controller.takePhoto();

                                    if (path != null) {
                                      final success = await controller
                                          .uploadStory(path);

                                      if (success) {
                                        Get.to(
                                          () => UploadStory(
                                            imagePath: path,
                                            mediaPath: controller
                                                .uploadedStory
                                                .value!
                                                .data!
                                                .path,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: Container(
                                    width: buttonSize,
                                    height: buttonSize,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 3,
                                      ),
                                    ),
                                    padding: EdgeInsets.all(buttonSize * 0.12),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // ================= FLIP CAMERA =================
                              Positioned(
                                right: 7.w,
                                top: 0,
                                bottom: 0,
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.switchCamera();
                                    },
                                    child: Icon(
                                      Icons.flip_camera_ios,
                                      color: Colors.white,
                                      size: 5.w,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),


                ],
              ),
            ),

            if (controller.isUploadingStory.value)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
