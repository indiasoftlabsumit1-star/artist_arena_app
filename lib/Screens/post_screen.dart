



import 'dart:io';

import 'package:artist_arena_app/Controllers/mystory_controller.dart';
import 'package:artist_arena_app/Utils/appThemeStyle.dart';
import 'package:artist_arena_app/Widgets/common_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CreatePostScreen extends StatelessWidget {
   CreatePostScreen({super.key});


  final controller=Get.put(MyStoryController());
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
                      onTap: () {
                        controller.pickFromGallery();
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

                            if (media != null) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(1.w),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight: height*0.50
                                  ),
                                  child: Image.file(
                                    File(media.path),
                                    width: double.infinity,
                                    height: height*0.50,

                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            }

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
                          child:CommonButtonWidget(btnName: 'Discard', btnText: AppColores.custtombtnColor, callback: (){})
                        ),

                        SizedBox(width: 3.w),

                        Expanded(
                          child: CommonButtonWidget(btnName: 'Post', btnText: Colors.white, callback: (){},btnBgColor: AppColores.custtombtnColor,)
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