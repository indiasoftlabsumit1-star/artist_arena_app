




import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../Controllers/mystory_controller.dart';
import 'home_screen.dart';

class UploadStory extends StatelessWidget {
  final String imagePath;
  final String mediaPath;

   UploadStory({
    super.key,
    required this.imagePath, required this.mediaPath,
  });

  final  controller =
  Get.find<MyStoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [

          // SELECTED / CAPTURED IMAGE
          Image.file(
            File(imagePath),
            fit: BoxFit.cover,
          ),

          // TOP LEFT BACK
          Positioned(
            top: 5.h,
            left: 4.w,
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

          // SHARE TO STORY BUTTON
          Positioned(
            bottom: 3.h,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () async{
                  final success = await controller.createStory(
                    media: mediaPath,

                  );

                  if (success) {
                    Get.offAll(() => Home());
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                    vertical: 1.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      3.w,
                    ),
                  ),
                  child: Text(
                    "Share To Story",
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
          if (controller.isUploadingStory.value)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}