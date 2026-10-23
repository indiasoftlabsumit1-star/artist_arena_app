import 'dart:math';
import 'dart:typed_data';

import 'package:artist_arena_app/Screens/upload_story.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sizer/sizer.dart';

import '../Controllers/mystory_controller.dart';

class MyStoryScreen extends StatelessWidget {
  MyStoryScreen({super.key});

  final MyStoryController controller =
  Get.put(MyStoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(
            () {
          return Stack(
            fit: StackFit.expand,
            children: [

              // ================= CAMERA PREVIEW =================

              if (controller.isCameraInitialized.value &&
                  controller.cameraController != null)
                Positioned.fill(
                  child: CameraPreview(
                    controller.cameraController!,
                  ),
                )
              else
                const Positioned.fill(
                  child: ColoredBox(
                    color: Colors.black,
                  ),
                ),

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
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 6.w,
                    ),
                  ),
                ),
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

                    SizedBox(
                      height: 10.h,
                      child: Obx(
                            () {
                          if (controller.recentImages.isEmpty) {
                            return const SizedBox();
                          }

                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            itemCount: controller.recentImages.length,
                            itemBuilder: (context, index) {
                              final image =
                              controller.recentImages[index];

                              return GestureDetector(
                                onTap: () async {
                                  final path =
                                  await controller.selectImage(image);

                                  if (path != null) {
                                    Get.to(
                                          () => UploadStory(
                                        imagePath: path,
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  width: 15.w,
                                  margin: EdgeInsets.only(right: 1.w),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(1.w),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(1.w),
                                    child: FutureBuilder<Uint8List?>(
                                      future: image.thumbnailDataWithSize(
                                        const ThumbnailSize(
                                          300,
                                          300,
                                        ),
                                      ),
                                      builder: (
                                          context,
                                          snapshot,
                                          ) {
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
                        },
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // ================= FLASH + CAMERA + FLIP =================

                    Builder(
                      builder: (context) {

                        final screenWidth =
                            MediaQuery.of(context).size.width;

                        // Camera button responsive rahega
                        final double buttonSize =
                        min(screenWidth * 0.18, 10.h);

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
                                    final path =
                                    await controller.takePhoto();

                                    if (path != null) {
                                      Get.to(
                                            () => UploadStory(
                                          imagePath: path,
                                        ),
                                      );
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
                                    padding: EdgeInsets.all(
                                      buttonSize * 0.12,
                                    ),
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
            ],
          );
        },
      ),
    );
  }
}