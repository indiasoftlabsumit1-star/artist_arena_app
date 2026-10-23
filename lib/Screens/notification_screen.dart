


import 'package:artist_arena_app/Widgets/profile_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../Utils/appThemeStyle.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final List<Map<String, String>> yesterdayNotifications = [
    {
      "image": "assets/images/profileimg.webp",
      "name": "Alisa Hester",
      "message": "here are a couple of reasons why I prefer Day trading over any other career.",
      "time": "03:55PM",
    },
    {
      "image": "assets/images/profileimg1.webp",
      "name": "Jaydin Jones",
      "message": "here are a couple of reasons why I prefer Day trading over any other career.",
      "time": "03:55PM",
    },
    {
      "image": "assets/images/profileimg2.webp",
      "name": "Inara Britt",
      "message": "here are a couple of reasons why I prefer Day trading over any other career.",
      "time": "03:55PM",
    },
    {
      "image": "assets/images/profileimg3.webp",
      "name": "Yousif Cross",
      "message": "here are a couple of reasons why I prefer Day trading over any other career.",
      "time": "03:55PM",
    },
  ];

  final List<Map<String, String>> todayNotifications = [
    {
      "image": "assets/images/profileimg.webp",
      "name": "Lilja Peltola",
      "message": "here are a couple of reasons why I prefer Day trading over any other career.",
      "time": "03:55PM",
    },
    {
      "image": "assets/images/profileimg1.webp",
      "name": "Dustin Mock",
      "message": "here are a couple of reasons why I prefer Day trading over any other career.",
      "time": "03:55PM",
    },
    {
      "image": "assets/images/profileimg2.webp",
      "name": "Lucy Bond",
      "message": "here are a couple of reasons why I prefer Day trading over any other career.",
      "time": "03:55PM",
    },
    {
      "image": "assets/images/profileimg3.webp",
      "name": "Sasha Ho",
      "message": "here are a couple of reasons why I prefer Day trading over any other career.",
      "time": "03:55PM",
    },
    {
      "image": "assets/images/profileimg1.webp",
      "name": "Dylan Ambrose",
      "message": "here are a couple of reasons why I prefer Day trading over any other career.",
      "time": "03:55PM",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Notification',style: Appthemestyle.poppins(
          fontSize: 18.sp
        ),),
        centerTitle:  true,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 1.5.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("Yesterday"),

                    SizedBox(height: 1.h),

                    ...yesterdayNotifications.map(
                          (item) => _notificationItem(item),
                    ),

                    SizedBox(height: 1.h),

                    _sectionTitle("Today"),

                    SizedBox(height: 1.h),

                    ...todayNotifications.map(
                          (item) => _notificationItem(item),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp.clamp(16.0, 18.0),
        fontWeight: FontWeight.w400,
        color: const Color(0xffA3A3A3),
      ),
    );
  }

  Widget _notificationItem(Map<String, String> item) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.3.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Image
         ProfileContainerWidget(img: item['image']!,width: 15.w.clamp(70.0, 110.0),height: 15.w.clamp(70.0, 110.0)),

          SizedBox(width: 2.5.w),

          // Name + Message
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["name"]!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.sp.clamp(14.0, 16.0),
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: 0.2.h),

                Text(
                  item["message"]!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp.clamp(12.0, 14.0),
                    height: 1.15,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 1.w),

          // Time
          Text(
            item["time"]!,
            style: TextStyle(
              fontSize: 15.sp.clamp(13.0, 15.0),
              color: const Color(0xff999999),
            ),
          ),
        ],
      ),
    );
  }
}