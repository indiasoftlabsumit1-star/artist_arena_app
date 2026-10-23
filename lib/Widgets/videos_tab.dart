

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

import '../Utils/appThemeStyle.dart';

class VideosTab extends StatelessWidget {

    final List<Map<String,String>> galleryImg=[
    {
      'image':"assets/images/videoimg.webp",

    },
    {
      'image':"assets/images/videoimg.webp",

    },
    {
      'image':"assets/images/videoimg.webp",

    },
    {
      'image':"assets/images/videoimg.webp",

    },
    {
      'image':"assets/images/videoimg.webp",

    },
    {
      'image':"assets/images/videoimg.webp",

    },

  ];


  final double width;
   VideosTab({super.key, required this.width});

  @override
  Widget build(BuildContext context) {



    return  LayoutBuilder(
      builder: (context, constraints) {
        // final double width=constraints.maxWidth;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: width>=1024?0.w:7.w),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: galleryImg.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: width>=1024?6:3,
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
                child: Center(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                     FontAwesomeIcons.youtube,
                     color: Colors.red,
                    ),
                    Text("How to use the Artist Arena",style: Appthemestyle.poppins(
                      color: Colors.white,
                      fontSize: 10.sp.clamp(4.0, 10.0)
                    ),)
                  ],
                ),),
              );
            },
          ),
        );
      }
    );
  }
}
