

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GalleryTab extends StatelessWidget {
    final List<Map<String,String>> galleryImg=[
    {
      'image':"assets/images/profileimg1.webp",

    },
    {
      'image':"assets/images/profileimg2.webp",

    },
    {
      'image':"assets/images/profileimg3.webp",

    },
    {
      'image':"assets/images/profileimg1.webp",

    },
    {
      'image':"assets/images/profileimg2.webp",

    },
    {
      'image':"assets/images/profileimg3.webp",

    },
    {
      'image':"assets/images/profileimg1.webp",

    },
    {
      'image':"assets/images/profileimg2.webp",

    },
    {
      'image':"assets/images/profileimg3.webp",

    },
  ];
   GalleryTab({super.key});

  @override
  Widget build(BuildContext context) {



    return LayoutBuilder(
      builder: (context, constraints) {

      final double width=constraints.maxWidth;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: width>=1024?0.w:7.w),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: galleryImg.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
              width>1024?6:3,
              crossAxisSpacing: 1.w,
              mainAxisSpacing: 1.h,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final item = galleryImg[index];

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.sp),
                  image: DecorationImage(
                    image: AssetImage(item['image']!),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        );
      }
    );
  }
}
