
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

import '../Controllers/mystory_controller.dart';
import 'home_screen.dart';

class UploadStory extends StatefulWidget {
  final String imagePath;
  final String mediaPath;
  final bool isVideo;

  const UploadStory({
    super.key,
    required this.imagePath,
    required this.mediaPath,
    this.isVideo = false,
  });

  @override
  State<UploadStory> createState() => _UploadStoryState();
}

class _UploadStoryState extends State<UploadStory> {
  final controller = Get.find<MyStoryController>();
  VideoPlayerController? videoController;
  bool isVideoReady = false;

  @override
  void initState() {
    super.initState();

    if (widget.isVideo) {
      initializeVideo();
    }
  }

  Future<void> initializeVideo() async {
    final player = VideoPlayerController.file(
      File(widget.imagePath),
    );

    videoController = player;

    try {
      await player.initialize();
      await player.setLooping(true);
      await player.play();

      if (mounted) {
        setState(() {
          isVideoReady = true;
        });
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar('Video Error', 'Unable to play selected video.');
      }
    }
  }

  @override
  void dispose() {
    videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (!widget.isVideo)
            Image.file(
              File(widget.imagePath),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.white,
                    size: 48,
                  ),
                );
              },
            )
          else if (isVideoReady && videoController != null)
            Center(
              child: AspectRatio(
                aspectRatio: videoController!.value.aspectRatio,
                child: VideoPlayer(videoController!),
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),

          Positioned(
            top: 5.h,
            left: 4.w,
            child: GestureDetector(
              onTap: Get.back,
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

          Positioned(
            bottom: 3.h,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () async {
                  final success = await controller.createStory(
                    media: widget.mediaPath,
                  );

                  if (success && mounted) {
                    Get.offAll(() => HomeScreen());
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                    vertical: 1.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3.w),
                  ),
                  child: Text(
                    'Share To Story',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Obx(() {
            if (!controller.isUploadingStory.value) {
              return const SizedBox.shrink();
            }

            return Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
