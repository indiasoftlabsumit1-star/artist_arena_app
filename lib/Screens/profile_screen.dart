



import 'package:artist_arena_app/Controllers/profile_controller.dart';
import 'package:artist_arena_app/Utils/appThemeStyle.dart';
import 'package:artist_arena_app/Widgets/about_tab.dart';
import 'package:artist_arena_app/Widgets/common_button_widget.dart';
import 'package:artist_arena_app/Widgets/gallery_tab.dart';
import 'package:artist_arena_app/Widgets/profile_container_widget.dart';
import 'package:artist_arena_app/Widgets/service_tab.dart';
import 'package:artist_arena_app/Widgets/videos_tab.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {




  List<Map<String,String>> profileImage=[
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
  ProfileController profileController=Get.find<ProfileController>();

  final List<Widget> icons = [
    Container(
      padding: EdgeInsets.all(12.sp),
      margin: EdgeInsets.only(right: 1.w),

      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xffDEDEDE),
      ),
      child: Center(
        child: FaIcon(
          FontAwesomeIcons.facebook,
          color: Colors.white,
          // size: 12.sp,

        ),
      ),
    ),

    Container(
      padding: EdgeInsets.all(12.sp),
      margin: EdgeInsets.only(right: 1.w),

      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xffDEDEDE),
      ),
      child: Center(
        child: FaIcon(
          FontAwesomeIcons.instagram,
          color: Colors.white,
          // size: 12.sp,

        ),
      ),
    ),

    Container(
      padding: EdgeInsets.all(12.sp),
      margin: EdgeInsets.only(right: 1.w),

      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xffDEDEDE),
      ),
      child: Center(
        child: FaIcon(
          FontAwesomeIcons.twitter,
          color: Colors.white,
          // size: 12.sp,

        ),
      ),
    ),

    Container(
      padding: EdgeInsets.all(12.sp),
      margin: EdgeInsets.only(right: 1.w),

      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xffDEDEDE),
      ),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(50.sp),
          child: FaIcon(
            FontAwesomeIcons.youtube,
            color: Colors.white,
            // size: 12.sp,

          ),
        ),
      ),
    ),

    Container(
      padding: EdgeInsets.all(12.sp),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xffDEDEDE),
      ),
      child: Center(
        child: FaIcon(
          FontAwesomeIcons.linkedin,
          color: Colors.white,
          // size: 12.sp,

        ),
      ),
    ),
    Spacer(),
    Container(
      padding: EdgeInsets.all(12.sp),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green,
      ),
      child: Center(
        child: FaIcon(
          FontAwesomeIcons.whatsapp,
          color: Colors.white,
          // size: 12.sp,

        ),
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
         body: Obx(
             (){
               final profile =profileController.profile.value;
               return
               profileController.profileLoading.value?Center(child: CircularProgressIndicator(),):LayoutBuilder(

             builder: (context, constraints) {
               final double width= constraints.maxWidth;
               final double height = constraints.maxHeight;

               // 1. Profile image ka clamped size calculate karo
               final double profileSize = 15.w.clamp(70.0, 110.0);
               bool landescape = width>height&&height<500;

           // 2. Camera icon ka size isi profileSize ke proportion mein rakho
               final double cameraRadius = profileSize * 0.18; // ~14px se 20px
               final double cameraIconSize = profileSize * 0.20;
               return SingleChildScrollView(
                 child: Center(
                   child: ConstrainedBox(
                     constraints: BoxConstraints(
                          maxWidth: width>=1024?width*0.85:landescape?width*0.85:double.infinity

                     ),
                     child: Column(
                       children: [
                          Container(
                               padding: EdgeInsetsGeometry.symmetric(horizontal: 5.w,vertical: 2.h),

                               decoration: BoxDecoration(
                                 color: Colors.white,
                                   boxShadow: [
                                     BoxShadow(
                                       color: Color(0x29000000),
                                       offset: Offset(0, 5),
                                       blurRadius: 10,
                                     ),
                                   ],
                                 borderRadius: BorderRadiusGeometry.only(bottomLeft: Radius.circular(25.sp),bottomRight: Radius.circular(25.sp))
                               ),
                               width: double.infinity,
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.center,
                                 children: [
                                   Stack(
                                     children: [
                                       ProfileContainerWidget(img: "assets/images/profileimg.webp",width: profileSize,height: profileSize,
                                         imageUrl: profileController.profile.value?.avatarUrl,
                                       ),
                                       Positioned(

                                           right: -5,
                                           bottom: 0,
                                           child: CircleAvatar(
                                         radius: cameraRadius,
                                         backgroundColor: Colors.white,
                                         child: Icon(Icons.camera_alt_outlined,color: Colors.black,size: cameraIconSize,),))
                                     ],
                                   ),
                                   SizedBox(height: 2.h,),
                                   Text("${profile?.name}",style: Appthemestyle.poppins(
                                     color: AppColores.custtombtnColor,
                                     fontSize: 18.sp.clamp(16.0, 18.0)
                                       ,fontWeight: FontWeight.bold
                                   ),),
                                   SizedBox(height: 2.h,),
                                   Text("We Are Rockstars is a Hungarian indie band based in Budapest, Hungary.",style: Appthemestyle.poppins(
                                     fontSize: 14.sp.clamp(12.0, 14.0)
                                   ),textAlign: TextAlign.center,),
                                   SizedBox(height: 2.h,),

                                   Text(profile!.mobile,style: Appthemestyle.poppins(
                                       fontSize: 14.sp.clamp(12.0, 14.0)
                                   )),
                                   SizedBox(height: 3.h,),


                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                     children: icons,
                                   )

                                 ],
                               ),
                             ),

                         SizedBox(height: 3.h,),
                         Obx(
                               () => Column(
                             children: [
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 children: [
                                   Expanded(
                                     child: _tabItem('About', 0, profileController),
                                   ),
                                   Expanded(
                                     child: _tabItem('Service', 1, profileController),
                                   ),
                                   Expanded(
                                     child: _tabItem('Gallery', 2, profileController),
                                   ),
                                   Expanded(
                                     child: _tabItem('Videos', 3, profileController),
                                   ),
                                 ],
                               ),

                               SizedBox(height: 4.h),

                               _getSelectedContent(profileController,width),
                             ],
                           ),
                         ),

                         SizedBox(height: 4.h,),
                          Padding(
                            padding: EdgeInsetsGeometry.symmetric(horizontal: width>=1024?0.w:5.w),
                            child: CommonButtonWidget(btnName: 'Pdf File Download', btnText: Colors.red, callback: (){

                                           },),
                          ),SizedBox(height: 2.h,),
                         Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: width>=1024?0.w:5.w),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text('Post',style: Appthemestyle.poppins(),),
                             SizedBox(height: 1,),
                             SizedBox(

                               child: GridView.builder(
                                 shrinkWrap: true,
                                 physics: const NeverScrollableScrollPhysics(),
                                 itemCount: profileImage.length,
                                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                   crossAxisCount: width  >1024?6:3,
                                   crossAxisSpacing: 2.w,
                                   mainAxisSpacing: 2.h,
                                 ),
                                 itemBuilder: (context, index) {
                                   final item = profileImage[index];

                                   return Container(
                                     alignment: Alignment.bottomCenter,
                                     padding: EdgeInsets.only(bottom: 3.h),
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
                             ),

                           ],
                         ),
                         )
                       ],
                     ),
                   ),
                 ),
               );
             }
           );}
         ),
    );
  }
}
Widget _tabItem(
    String title,
    int index,
    ProfileController controller,
    ) {
  final isSelected = controller.selectedIndex.value == index;

  return GestureDetector(
    onTap: () {
      controller.changeTab(index);
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style:  Appthemestyle.poppins(
            fontSize: 14.sp.clamp(12.0, 14.0),
            fontWeight: isSelected
                ? FontWeight.w600
                : FontWeight.w400,
            color: isSelected
                ? AppColores.custtombtnColor
                : Color(0xff666666)
          ),
        ),

        // SizedBox(height: 6.h),

        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 0.5
              .h,
          width: isSelected ? 20.w : 0,
          decoration: BoxDecoration(
            color: AppColores.custtombtnColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    ),
  );
}

Widget _getSelectedContent(ProfileController controller ,double width) {
  switch (controller.selectedIndex.value) {
    case 0:
      return AboutTab();

    case 1:
      return ServiceTab();

    case 2:
      return GalleryTab();

    case 3:
      return VideosTab(width: width);

    default:
      return AboutTab();
  }
}