import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../Utils/appThemeStyle.dart';
class StoryScreen extends StatelessWidget {
  final String storyImage;
  final String storyName;

  const StoryScreen({
    super.key,
    required this.storyImage,
    required this.storyName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,

          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(storyImage),
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
          ),

          child: Stack(
            children: [

              // Top profile and name
              Positioned(
                top: 1.h,
                left: 3.w,
                right: 3.w,
                child: Row(
                  children: [

                    ClipOval(
                      child: Image.asset(
                        storyImage,
                        width: 9.w,
                        height: 9.w,
                        fit: BoxFit.cover,
                      ),
                    ),

                    SizedBox(width: 2.w),

                    Expanded(
                      child: Text(
                        '$storyName 15h',
                        style: Appthemestyle.poppins(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 6.w,
                      ),
                    ),
                  ],
                ),
              ),

              // Comment box
              Positioned(
                left: 3.w,
                right: 3.w,
                bottom: 1.5.h,
                child: Container(
                  height: 5.h,
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.sp),
                  ),
                  child: Row(
                    children: [

                      Expanded(
                        child: Text(
                          'Add a comment...',
                          style: Appthemestyle.poppins(
                            color: Color(0xff999999),
                            fontSize: 14.sp,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: double.infinity,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Icon(
                            Icons.send,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}