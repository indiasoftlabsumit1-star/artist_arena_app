


import 'package:artist_arena_app/Screens/login_screen.dart';
import 'package:artist_arena_app/Screens/signup_screen.dart';
import 'package:artist_arena_app/Utils/appThemeStyle.dart';
import 'package:artist_arena_app/Widgets/common_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class OnbordingScreen extends StatefulWidget {
  const OnbordingScreen({super.key});

  @override
  State<OnbordingScreen> createState() => _OnbordingScreenState();
}

class _OnbordingScreenState extends State<OnbordingScreen> {

  final List<Map<String,String>> onboardingList=[
    {
      "image":"assets/images/onbordingimg.png",
      "title1":"Lorem Ipsum is simply dummy text of the printing  and typesetting industry",
      "title2":"Lorem Ipsum has been the industry  standard dummy text ever",

    },
    {
      "image":"assets/images/onbordingimg.png",
      "title1":"Lorem Ipsum is simply dummy text of the printing  and typesetting industry",
      "title2":"Lorem Ipsum has been the industry  standard dummy text ever"
    },
    {
      "image":"assets/images/onbordingimg.png",
      "title1":"Lorem Ipsum is simply dummy text of the printing  and typesetting industry",
      "title2":"Lorem Ipsum has been the industry  standard dummy text ever"
    }
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: Color(0xffF9FAFC),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double width=constraints.maxWidth;
          final double height = constraints.maxHeight;

          bool landescape = width>height&&height<500;
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: width >= 1024 ?width*0.85 :landescape?width*0.85: double.infinity,
              ),
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: width >= 600 ? 30 : 7.w,),
                child:
                Stack(

                  children: [
                    PageView.builder(
                      itemCount: onboardingList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final item=onboardingList[index];

                        return   Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: double.infinity,
                                height: 25.h,
                                child: Image.asset(item['image']!)),

                            Text("Welcome",style: Appthemestyle.poppins(fontSize: 18.sp,fontWeight: FontWeight.w600,color: Colors.black),),
                            SizedBox(height: 2.h,),
                            Text("${item["title1"]}",textAlign: TextAlign.center,style: Appthemestyle.poppins(
                                color: Color(0xff707070),
                                fontSize: 14.sp
                            ),),
                            SizedBox(height: 2.h,),
                            Text("${item['title2']}",textAlign: TextAlign.center,style: Appthemestyle.poppins(
                                color: Color(0xff707070),
                                fontSize: 14.sp
                            ),),
                            SizedBox(height: 5.h,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                onboardingList.length,
                                    (i) => Container(
                                      width: width >= 600 ? 60 : 10.w,                                  height: 0.5.h,
                                  margin: EdgeInsets.symmetric(horizontal: width >= 600 ? 6 : 1.w,),
                                  color: i == index ? AppColores.custtombtnColor : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        );
                      },),

                    Positioned(
                        left: 0,
                        right: 0,
                        bottom: 30,

                        child: Column(
                          children: [
                            CommonButtonWidget(btnName: "Create Account",
                                btnBgColor: AppColores.custtombtnColor, btnText: Colors.white, callback: (){
                                  Get.to(()=> SignupScreen());
                                }),SizedBox(height: 2.h,),
                            CommonButtonWidget(btnName: "Login",
                                btnText: AppColores.custtombtnColor, callback: (){
                                  Get.to(()=>LoginScreen());

                                }),
                          ],
                        )),

                  ],

                )
                ,
              ),
            ),
          );
        }
      ),
    );
  }
}
