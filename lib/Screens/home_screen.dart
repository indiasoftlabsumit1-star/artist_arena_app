


import 'dart:math';

import 'package:artist_arena_app/Controllers/auth_controller.dart';
import 'package:artist_arena_app/Controllers/feed_controller.dart';
import 'package:artist_arena_app/Controllers/home_controller.dart';
import 'package:artist_arena_app/Controllers/profile_controller.dart';
import 'package:artist_arena_app/Screens/my_story_screen.dart';
import 'package:artist_arena_app/Screens/notification_screen.dart';
import 'package:artist_arena_app/Screens/post_screen.dart';
import 'package:artist_arena_app/Screens/profile_screen.dart';
import 'package:artist_arena_app/Screens/search_screen.dart';
import 'package:artist_arena_app/Screens/setting_screen.dart';
import 'package:artist_arena_app/Screens/story_screen.dart';
import 'package:artist_arena_app/Widgets/custom_bottom_widget.dart';
import 'package:artist_arena_app/Widgets/profile_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../Utils/appThemeStyle.dart';
import '../Widgets/post_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  HomeController homeController = Get.put(HomeController());
  final authController=Get.find<AuthController>();
final profileController=Get.put(ProfileController());
  final FeedController feedController=Get.put(FeedController());


@override
  void initState() {
    // TODO: implement initState
  profileController.getProfile();
  feedController.getFeed();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    // final size=MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        final  double width=constraints.maxWidth;

        final double height = constraints.maxHeight;

        // Mobile Landscape Check
        final bool isMobileLandscape = height < 500 && width > height;
        return Obx(() {
          return Scaffold(

            appBar: homeController.selectedIndex.value == 4||homeController.selectedIndex.value==2
                ? null
                : AppBar(
              backgroundColor: Color(0xffF9FAFC),
              actionsPadding: EdgeInsets.only(right: 5.w),
              title: Text(homeController.currentTitle,style: Appthemestyle.poppins(color: Color(0xff1E2023),fontSize: 18.sp),),
              centerTitle: true,
              actions: [
                InkWell(
                    onTap: (){
                      Get.to(()=>NotificationScreen());
                    },
                    child: Icon(Icons.notifications_none_outlined)),
              ],
              leading: Builder(
                builder: (context) {
                  return IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: Icon(Icons.menu),
                  );
                },
              ),
            ),

            drawer: Drawer(
              width:width*0.60,
              backgroundColor: Color(0xffF9FAFC),
              child: Padding(
                padding: EdgeInsets.only(top: 5.h),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Column(
                          children: [
                           ProfileContainerWidget(img: 'assets/images/profileimg.webp'),
                            SizedBox(height: 1.h),
                            Text(
                              "Lovell005",
                              style: Appthemestyle.poppins(color: AppColores.custtombtnColor,fontWeight: FontWeight.w600,fontSize: 16.sp),
                            ),
                            SizedBox(height: 1.h),
                            Text("Dasia Lovell",style: Appthemestyle.poppins(fontSize: 14.sp),),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 3.h),

                     ListTile(
                        onTap: () {
                          Get.back(); // Drawer close hoga
                          Get.find<HomeController>().selectedIndex.value = 4;
                        },
                        leading: Icon(Icons.settings_outlined),
                        title: Text('Setting',style: Appthemestyle.poppins(),),
                      ),


                    SizedBox(height: 1.h),

                    ListTile(

                      onTap: (){
                        Get.back();
                        authController.logOut();
                      },

                      leading: Icon(Icons.logout),
                      title: Text('Logout',style: Appthemestyle.poppins(),),
                    ),
                  ],
                ),
              ),
            ),

            body:isMobileLandscape?

                 Row(

                   crossAxisAlignment: CrossAxisAlignment.stretch,
                   children: [
                     Expanded(
                       child: switch (homeController.selectedIndex.value) {
                        4 => SettingScreen(),
                        3=> ProfileScreen(),
                                       2=> MyStoryScreen(),
                                       1=>SearchScreen(),
                        _ => Home(),
                                       },
                     ),
                   CustomRightNav()
                   ],
                 ):
            switch (homeController.selectedIndex.value) {
              4 => SettingScreen(),
              3=> ProfileScreen(),
              2=> MyStoryScreen(),
              1=>SearchScreen(),
              _ => Home(),
            }
             ,

            bottomNavigationBar: isMobileLandscape?null:CustomBottomNav(),
          );
        });
      }
    );
  }
}


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController commentController=TextEditingController();


  final List<Map<String,String>>   homeStory=[
    {
      'storyimg':'assets/images/profileimg.webp'
      ,'name':'Dasia Lovell'
    },
    {
      'storyimg':'assets/images/searchtapimg1.webp'
      ,'name':'David'
    },
    {
      'storyimg':'assets/images/searchtapimg2.webp'
      ,'name':'jhon'
    },
    {
      'storyimg':'assets/images/profileimg2.webp'
      ,'name':'denny'
    },
  ];


  final List<Map<String, String>> homePosts = [
    {
      'profileImg': 'assets/images/profileimg1.webp',
      'username': 'Skillboxofficial',
      'category': 'Musician/band',
      'postImg': 'assets/images/profileimg1.webp',
      'likes': '2,760',
      'caption':
      'whatcommunity Hey everyone browsing on the Explore page. Appreciate the support. Consider giving me a follow.',
      'comments': '17',
    },
    {
      'profileImg': 'assets/images/searchtapimg1.webp',
      'username': 'devid',
      'category': 'Comendian',
      'postImg': 'assets/images/searchtapimg1.webp',
      'likes': '2,000',
      'caption':
      'whatcommunity Hey everyone browsing on the Explore page. Appreciate the support. Consider giving me a follow.',
      'comments': '0',
    },
  ];

  final List<Map<String, String>> comments = [
    {
      'image': 'assets/images/profileimg.webp',
      'name': 'Vera Huo',
      'comment': 'here are a couple of reasons why I prefer Day trading over any other career..',
    },
    {
      'image': 'assets/images/profileimg1.webp',
      'name': 'Lian ONeil',
      'comment': 'There are a couple of reasons why I prefer Day trading over any other career.'
    },
    {
      'image': 'assets/images/profileimg2.webp',
      'name': 'Ellis Scheaffer',
      'comment': 'here are a couple of reasons why I prefer Day trading over any other career.!',
    },
    {
      'image': 'assets/images/profileimg.webp',
      'name': 'Lory Ann',
      'comment': 'here are a couple of reasons why I prefer Day trading over any other career.!',
    },
  ];

  void _showCommentsBottomSheet(BuildContext context,int postId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.sp),
          topRight: Radius.circular(15.sp),
        ),
      ),

      constraints: const BoxConstraints(
        maxWidth: double.infinity,
      ),

      builder: (context) {
        return SizedBox(
          height: 45.h,
          width: double.infinity,
          child: Obx(
            (){
              return feedController.loading.value?Center(child: CircularProgressIndicator())


                  :
              Stack(
                children:[ Column(
                  children: [

                    // Header
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Comments',
                            style: Appthemestyle.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),

                          const Spacer(),

                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.close,
                              size: 5.w,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Divider(
                      height: 1,
                      color: Colors.grey.shade300,
                    ),

                    // Comments
                    feedController.commentList.isEmpty?Align(alignment: Alignment.center,child: Text('No Comment'),):Expanded(
                      child: ListView.builder(
                        itemCount: feedController.commentList.length,
                        itemBuilder: (context, index) {
                          final comment = feedController.commentList[index];

                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 1.h,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                // Profile image
                                ClipOval(
                                  child: comment.user.avatarUrl == null ||
                                      comment.user.avatarUrl!.isEmpty
                                      ? Icon(
                                    Icons.person,
                                    size: 9.w,
                                  )
                                      : Image.network(
                                    comment.user.avatarUrl!,
                                    width: 9.w,
                                    height: 9.w,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.person,
                                        size: 9.w,
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(width: 2.w),

                                // Name + comment
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        comment.user.name,
                                        style: Appthemestyle.poppins(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                      Text(
                                        comment.comment,
                                        style: Appthemestyle.poppins(
                                          fontSize: 14.sp,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),


                  ],
                ),



                  // Comment input
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18.sp,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: const AssetImage(
                              'assets/images/profileimg.webp',
                            ),
                          ),

                          SizedBox(width: 2.w),

                          Expanded(
                            child: TextField(
                              controller: commentController,
                              decoration: InputDecoration(
                                hintText: 'Add a comment...',
                                hintStyle: Appthemestyle.poppins(
                                  fontSize: 9.sp,
                                  color: Colors.grey,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 3.w,
                                  vertical: 1.h,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.sp),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.sp),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.sp),
                                  borderSide: BorderSide(
                                    color: AppColores.custtombtnColor,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 2.w),

                          GestureDetector(
                            onTap: () {
                             feedController.addComment(postId: postId, comment: commentController.text);
                            },
                            child: Text(
                              'Send',
                              style: Appthemestyle.poppins(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColores.custtombtnColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
             ] );
            },
          ),
        );
      },
    );
  }


  final List<Map<String, String>> like = [
    {
      'image': 'assets/images/profileimg.webp',
      'name': 'Katherine Moss liked your photo.',

    },
    {
      'image': 'assets/images/profileimg1.webp',
      'name': 'Kianna Pham liked your photo.',

    },
    {
      'image': 'assets/images/profileimg2.webp',
      'name': 'Jakobe Snell liked your photo.',
    },
    {
      'image': 'assets/images/profileimg.webp',
      'name': 'Bonnie Riley liked your photo.',
    },
    {
      'image': 'assets/images/profileimg.webp',
      'name': 'Alisa Hester liked your photo.',
    },
  ];
  void _showLikeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.sp),
          topRight: Radius.circular(15.sp),
        ),
      ),

      constraints: const BoxConstraints(
        maxWidth: double.infinity,
      ),



      builder: (context) {
        return SizedBox(
          height: 45.h,
          width: double.infinity,
          child: Obx(
            (){
              return feedController.loading.value?Center(child: CircularProgressIndicator(),):Column(

                children: [

                  // Header
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.h,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Like',
                          style: Appthemestyle.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),

                        const Spacer(),

                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close,
                            size: 5.w,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(
                    height: 1,
                    color: Colors.grey.shade300,
                  ),

                  // Comments
                  feedController.likeItem.isEmpty?Align(alignment: AlignmentGeometry.bottomCenter,child: Text(" No Likes"),):  Expanded(
                    child: ListView.builder(
                      itemCount: feedController.likeItem.length,
                      itemBuilder: (context, index) {
                        final like = feedController.likeItem[index];

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 1.h,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              // Profile image
                              ClipOval(
                                child: like.avatarUrl == null ||
                                    like.avatarUrl!.isEmpty
                                    ? Icon(
                                  Icons.person,
                                  size: 9.w,
                                )
                                    : Image.network(
                                  like.avatarUrl!,
                                  width: 9.w,
                                  height: 9.w,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.person,
                                      size: 9.w,
                                    );
                                  },
                                ),
                              ),

                              SizedBox(width: 2.w),

                              // Name + comment
                              Expanded(

                                child: Text(
                                  like.name,
                                  style: Appthemestyle.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),




                              ),
                              SizedBox(width: 2.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                  vertical: 0.7.h,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColores.custtombtnColor,
                                  ),
                                  borderRadius: BorderRadius.circular(20.sp),
                                ),
                                child: Text(
                                  'Follow',
                                  style: Appthemestyle.poppins(
                                    fontSize: 12.sp,
                                    color: AppColores.custtombtnColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Comment input
                  // Container(
                  //   padding: EdgeInsets.symmetric(
                  //     horizontal: 3.w,
                  //     vertical: 1.h,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     border: Border(
                  //       top: BorderSide(
                  //         color: Colors.grey.shade300,
                  //       ),
                  //     ),
                  //   ),
                  //   child: Row(
                  //     children: [
                  //
                  //       Expanded(
                  //         child: TextField(
                  //           decoration: InputDecoration(
                  //             hintText: 'Add a comment...',
                  //             hintStyle: Appthemestyle.poppins(
                  //               fontSize: 8.sp,
                  //               color: Colors.grey,
                  //             ),
                  //             border: InputBorder.none,
                  //           ),
                  //         ),
                  //       ),
                  //
                  //       Text(
                  //         'Send',
                  //         style: Appthemestyle.poppins(
                  //           fontSize: 8.sp,
                  //           fontWeight: FontWeight.w500,
                  //           color: AppColores.custtombtnColor,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  final feedController=Get.find<FeedController>();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;

        bool landescape = width > height && height < 500;
        final double cardHeight = min(
          width * 0.20 / 0.68,
          landescape ? height * 0.40 : width >= 600 ? height * 0.30 : height * 0.58,
        );

        final double cardWidth = landescape ? cardHeight * 1.0 : cardHeight * 0.70;

        return Scaffold(
          backgroundColor: const Color(0xffF9FAFC),
          body: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: width >= 1024 ? width * 0.85 : landescape ? width * 0.85 : double.infinity,
              ),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // 1. Post Input / Create Box Section
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Container(
                          margin: landescape ? null : EdgeInsets.symmetric(horizontal: width >= 1024 ? 0.w : 5.w),
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w.clamp(1.w, 2.w),
                            vertical: 1.h.clamp(1.h, 1.h),
                          ),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x1A000000),
                                offset: Offset(0, 0),
                                blurRadius: 30,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(11.sp),
                          ),
                          child: Row(
                            children: [
                              ProfileContainerWidget(
                                img: "assets/images/profileimg.webp",
                                width: 5.w.clamp(1.w, 4.w),
                                height: 5.w.clamp(1.sp, 4.w),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Write somethings here...',
                                    hintStyle: Appthemestyle.poppins(
                                      color: const Color(0xff666666),
                                      fontSize: 12.sp,
                                    ),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              const Icon(Icons.photo_outlined),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => CreatePostScreen());
                                },
                                child: Text('photo/video', style: Appthemestyle.poppins(fontSize: 12.sp)),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),

                  // 2. Horizontal Story List Section
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width >= 1024 ? 0.w : landescape ? 0 : 5.w),
                          child: SizedBox(
                            height: cardHeight,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.horizontal,
                              itemCount: homeStory.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return GestureDetector(
                                    onTap: () async {
                                      final result = await Get.to(() => MyStoryScreen());
                                      if (result != null) {
                                        print("Selected story image: $result");
                                      }
                                    },
                                    child: Container(
                                      width: cardWidth,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10.sp),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x1A000000),
                                            offset: Offset(0, 0),
                                            blurRadius: 10,
                                          ),
                                        ],
                                      ),
                                      child: IntrinsicHeight(
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10.sp),
                                                  topRight: Radius.circular(10.sp),
                                                ),
                                                child: Image.asset(
                                                  "assets/images/profileimg.webp",
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: landescape ? cardWidth * 0.40 : cardWidth * 0.40,
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                alignment: Alignment.center,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(top: cardWidth * 0.07),
                                                    child: Center(
                                                      child: Text(
                                                        "Create a story",
                                                        style: Appthemestyle.poppins(
                                                          fontSize: 12.sp.clamp(6.0, 12.0),
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: landescape ? -(cardWidth * 0.12) : -(cardWidth * 0.10),
                                                    child: Container(
                                                      width: cardWidth * 0.27,
                                                      height: cardWidth * 0.27,
                                                      decoration: const BoxDecoration(
                                                        color: Colors.black,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                        size: cardWidth * 0.20,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                final item = homeStory[index - 1];
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(
                                          () => StoryScreen(
                                        storyImage: item['storyimg']!,
                                        storyName: item['name']!,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: cardWidth,
                                    margin: EdgeInsets.only(left: 2.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.sp),
                                      image: DecorationImage(
                                        image: AssetImage(item['storyimg']!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          height: cardWidth * 0.30,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(10.sp),
                                                bottomRight: Radius.circular(10.sp),
                                              ),
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.black.withOpacity(0.65),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: cardWidth * 0.05,
                                          left: cardWidth * 0.08,
                                          child: Container(
                                            width: cardWidth * 0.27,
                                            height: cardWidth * 0.27,
                                            padding: EdgeInsets.all(cardWidth * 0.013),
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                            child: ClipOval(
                                              child: Image.asset(
                                                item['storyimg']!,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: cardWidth * 0.08,
                                          bottom: cardWidth * 0.05,
                                          child: Text(
                                            item['name']!,
                                            style: Appthemestyle.poppins(
                                              color: Colors.white,
                                              fontSize: 12.sp.clamp(6.0, 12.0),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),

                  // 3. Optimized Posts Feed using SliverList
                  Obx(
                  ()=> SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                            final post=feedController.feedList[index];
                        return  Container(
                              margin: EdgeInsets.only(bottom: 2.h),
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Post Header
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 3.w,
                                      vertical: 1.h,
                                    ),
                                    child: Row(
                                      children: [
                                        ProfileContainerWidget(
                                          imageUrl: post.user.avatarUrl,
                                          width: width >= 600 ? 5.w : 7.w,
                                          height: width >= 600 ? 5.w : 7.w,
                                          icon: post.user.avatarUrl==null?'person':null,
                                        ),
                                        SizedBox(width: 2.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                               post.user.name,
                                                style: Appthemestyle.poppins(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                post.user.category!,
                                                style: Appthemestyle.poppins(
                                                  fontSize: 12.sp,
                                                  color: const Color(0xff666666),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                    
                                  // Post Image
                                  // Post Image / Video
                                  if (post.media.isNotEmpty)
                                    Builder(
                                      builder: (context) {
                                        final media = post.media.first;
                                        final isVideo = media.type.toLowerCase() == 'video';

                                        if (isVideo) {
                                          return FeedVideoPlayer(
                                            videoUrl: media.url,
                                          );
                                        }

                                        return SizedBox(
                                          width: double.infinity,
                                          child: Image.network(
                                            media.url,
                                            width: double.infinity,
                                            fit: BoxFit.fitWidth,
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }

                                              return SizedBox(
                                                width: double.infinity,
                                                height: 30.h,
                                                child: const Center(
                                                  child: CircularProgressIndicator(),
                                                ),
                                              );
                                            },
                                            errorBuilder: (context, error, stackTrace) {
                                              return const SizedBox.shrink();
                                            },
                                          ),
                                        );
                                      },
                                    ),
                    
                                  // Like / Comment / Share
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 3.w.clamp(10.0, 20.0),
                                      vertical: 1.h,
                                    ),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            print('Favorite icon tapped: ${post.id}');

                                            if (post.isLiked) {
                                              feedController.unLike(post.id);
                                            } else {
                                              feedController.like(post.id);
                                            }     },
                                          child: Icon(
                                            post.isLiked == true
                                                ? Icons.favorite
                                                : Icons.favorite_outline,
                                            color: post.isLiked == true
                                                ? Colors.red
                                                : Colors.black,
                                            size: 20.sp.clamp(18.0, 30.0),
                                          ),
                                        ),
                                        SizedBox(width: 3.w.clamp(2.0, 30.0)),
                                        GestureDetector(
                                          onTap: () {
                                            feedController.getComment(post.id);
                                            _showCommentsBottomSheet(context,post.id);
                                          },
                                          child: Icon(
                                            Icons.chat_bubble_outline,
                                            color: Colors.black,
                                            size: 20.sp.clamp(18.0, 30.0),
                                          ),
                                        ),
                                        SizedBox(width: 3.w.clamp(2.0, 30.0)),
                                        Icon(
                                          Icons.share_outlined,
                                          color: Colors.black,
                                          size: 20.sp.clamp(18.0, 30.0),
                                        ),
                                        const Spacer(),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 4.w,
                                            vertical: 0.7.h,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: AppColores.custtombtnColor,
                                            ),
                                            borderRadius: BorderRadius.circular(20.sp),
                                          ),
                                          child: Text(
                                            'Follow',
                                            style: Appthemestyle.poppins(
                                              fontSize: 12.sp,
                                              color: AppColores.custtombtnColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                    
                                  // Likes Count
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 3.w.clamp(10.0, 20.0)),
                                    child: InkWell(
                                      onTap: (){
                                        feedController.getLikes(post.id);
                                        _showLikeBottomSheet(context);
                                      },
                                      child: Text(

                                        'Likes ${post.likesCount}',
                                        style: Appthemestyle.poppins(
                                          fontSize: 14.sp.clamp(12.0, 14.0),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 0.8.h),
                    
                                  // Caption
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 3.w.clamp(10.0, 20.0)),
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: post.user.name,
                                            style: Appthemestyle.poppins(
                                              fontSize: 14.sp.clamp(12.0, 14.0),
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '  ${post.caption}',
                                            style: Appthemestyle.poppins(
                                              fontSize: 14.sp.clamp(12.0, 14.0),
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 0.8.h),
                    
                                  // Comments Summary
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 3.w.clamp(10.0, 20.0)),
                                    child: InkWell(
                                      onTap: (){
                                        feedController.getComment(post.id);
                                        _showCommentsBottomSheet(context,post.id);
                                      },
                                      child: Text(
                                        'View all ${post.commentsCount} comments',
                                        style: Appthemestyle.poppins(
                                          fontSize: 14.sp.clamp(12.0, 14.0),
                                          color: const Color(0xff777777),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                    
                                  // Add Comment Row
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 3.w.clamp(10.0, 20.0)),
                                    child: Row(
                                      children: [
                                        ProfileContainerWidget(
                                          img: 'assets/images/profileimg.webp',
                                          height: 5.w.clamp(30.0, 50.0),
                                          width: 5.w.clamp(30.0, 50.0),
                                        ),
                                        SizedBox(width: 2.w),
                                        Expanded(
                                          child: Text(
                                            'Add a comment...',
                                            style: Appthemestyle.poppins(
                                              fontSize: 14.sp.clamp(12.0, 14.0),
                                              color: const Color(0xff999999),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Send',
                                          style: Appthemestyle.poppins(
                                            fontSize: 14.sp.clamp(12.0, 14.0),
                                            fontWeight: FontWeight.w500,
                                            color: AppColores.custtombtnColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 1.5.h),
                                ],
                              ),
                            
                          );
                        },
                        childCount: feedController.feedList.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

