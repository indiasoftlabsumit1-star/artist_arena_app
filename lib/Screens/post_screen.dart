



import 'dart:io';

import 'package:artist_arena_app/Controllers/feed_controller.dart';
import 'package:artist_arena_app/Utils/appThemeStyle.dart';
import 'package:artist_arena_app/Widgets/common_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

import '../Controllers/profile_controller.dart';

class CreatePostScreen extends StatefulWidget {
   CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final controller=Get.put(FeedController());

  final profileController=Get.find<ProfileController>();

  final  TextEditingController captionController=TextEditingController();
  VideoPlayerController? videoController;

  Future<void> initializeVideo(String path) async {
    await videoController?.dispose();

    final newController = VideoPlayerController.file(File(path));
    videoController = newController;

    try {
      await newController.initialize();
      await newController.play();
      print('Video initialized: ${newController.value.isInitialized}');
      print('Video initialization error: ${newController.value.errorDescription}');

      if (mounted && videoController == newController) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('Video initialization error: $e');

      if (mounted) {
        setState(() {});
        Get.snackbar('Error', 'Unable to load video preview');
      }
    }
  }

  @override
  void initState() {
    super.initState();

    controller.selectedMedia.value = null;
    controller.uploadedPostMediaPath = null;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9FAFC),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,



        title: Text(
          "Create Post",
          style: Appthemestyle.poppins(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),

      body: LayoutBuilder(
        builder:(context, constraints) {

        final double width=constraints.maxWidth;

        final double height=constraints.maxHeight;
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 5.w,
              vertical: 1.5.h,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width>=1024?width*0.85:double.infinity),
                child: Column(
                  children: [

                    // Upload Image / Video
                    GestureDetector(
                      onTap: () async {
                        await controller.pickFromGallery();

                        final media = controller.selectedMedia.value;

                        if (media != null &&
                            ((media.mimeType?.startsWith('video/') ?? false) ||
                                ['mp4', 'mov', 'avi', 'mkv', 'webm']
                                    .contains(media.path.split('.').last.toLowerCase()))) {
                          await initializeVideo(media.path);
                        } else {
                          await videoController?.dispose();
                          videoController = null;
                        }
                      },
                      child: Container(
                        width: double.infinity,
                         height:controller.selectedMedia.value!=null?height*0.50: 35.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(1.w),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x29000000),
                              offset: const Offset(0, 1),
                              blurRadius: 5,
                            ),
                          ],
                        ),

                        child: Obx(() {
                          final media = controller.selectedMedia.value;

                          if (media == null) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.upload_outlined,
                                  color: Colors.black,
                                  size: 10.w,
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  "Upload a photo & video",
                                  style: Appthemestyle.poppins(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "(jpg, png, Video)",
                                  style: Appthemestyle.poppins(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            );
                          }

                          final isVideo = media.mimeType?.startsWith('video/') ??
                              ['mp4', 'mov', 'avi', 'mkv', 'webm']
                                  .contains(media.path.split('.').last.toLowerCase());

                          if (controller.mediaLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (!isVideo) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(1.w),
                              child: Image.file(
                                File(media.path),
                                width: double.infinity,
                                height: height * 0.50,
                                fit: BoxFit.cover,
                              ),
                            );
                          }

                          final video = videoController;

                          if (video == null || !video.value.isInitialized) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (video.value.isPlaying) {
                                  video.pause();
                                } else {
                                  video.play();
                                }
                              });
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [

                              SizedBox(
                              width: double.infinity,
                              height: height * 0.50,
                              child: VideoPlayer(video),
                            ),

                                Icon(
                                  video.value.isPlaying
                                      ? Icons.pause_circle
                                      : Icons.play_circle,
                                  color: Colors.white,
                                  size: 48,
                                ),
                              ],
                            ),
                          );
                        }),

                      ),
                    ),

                    SizedBox(height: 1.h),

                    // Description
                    SizedBox(
                      width: double.infinity,
                      height: 9.h,


                      child: TextField(
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        controller: captionController,
                        style: Appthemestyle.poppins(
                          fontSize: 10.sp,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: "Write something here...",
                          hintStyle: Appthemestyle.poppins(
                            fontSize: 14.sp,
                            color: Colors.black,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 1.w,
                            vertical: 1.h,
                          ),

                          suffixIcon: Padding(
                            padding: EdgeInsets.only(
                              right: 1.w,
                              bottom: 4.h,
                            ),
                            child: Icon(
                              Icons.emoji_emotions_outlined,
                              color: Colors.grey,
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Bottom Buttons
                    Row(
                      children: [

                        Expanded(
                          child:CommonButtonWidget(btnName: 'Discard', btnText: AppColores.custtombtnColor, callback: (){
                            Get.back();
                          })
                        ),

                        SizedBox(width: 3.w),

                        Expanded(
                          child: CommonButtonWidget(btnName: 'Post', btnText: Colors.white, callback: ()async{
                            final caption = captionController.text.trim();
                            final mediaPath = controller.uploadedPostMediaPath;
                            if (mediaPath == null || mediaPath.isEmpty) {
                              Get.snackbar('Error', 'Please upload an image or video first');
                              return;
                            }

                            await controller.post(
                              caption: caption,
                                media: [mediaPath],);

                          },btnBgColor: AppColores.custtombtnColor,)
                        ),
                      ],
                    ),

                    SizedBox(height: 1.h),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}