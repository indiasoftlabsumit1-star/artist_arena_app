


import 'package:artist_arena_app/Controllers/auth_controller.dart';
import 'package:artist_arena_app/Screens/signup_screen.dart';
import 'package:artist_arena_app/Utils/validator.dart';
import 'package:artist_arena_app/Widgets/common_button_widget.dart';
import 'package:artist_arena_app/Widgets/textField_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sizer/sizer.dart';

import '../Utils/appThemeStyle.dart';

class LoginScreen extends StatefulWidget {

  final String? mobile;
  final String? otp;
  const LoginScreen({super.key,  this.mobile,  this.otp});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final mobileController=TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final authController=Get.find<AuthController>();

@override
  void dispose() {
    // TODO: implement dispose
  mobileController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: LayoutBuilder(
        builder:  (context, constraints) {

        final double width=constraints.maxWidth;
        final double height = constraints.maxHeight;

        bool landescape = width>height&&height<500;
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: width >= 1024 ?width*0.85 :landescape?width*0.85: double.infinity,
              ),
              child: SingleChildScrollView(
                child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 7.w
                
                
                ),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Login",style: Appthemestyle.poppins(fontSize: 20.sp.clamp(18.0, 25.0),fontWeight: FontWeight.w600),),
                      SizedBox(height: 2.h,),
                      SizedBox(
                          width: double.infinity,
                          height: 20.h,
                          child: Image.asset("assets/images/loginimg.png")),                    Text("Login With Your Mobile Number",style: Appthemestyle.poppins(fontSize: 16.sp.clamp(14.0, 25.0),fontWeight: FontWeight.w700,height: 0.5)),
                      SizedBox(height: 2.h,),
                      Text("Your information is safe with us",style: Appthemestyle.poppins(fontSize: 14.sp.clamp(12.0, 20.0),color: Color(0xff707070),height: 0.5)),
                      SizedBox(height: 2.h,),
                      Row(
                        mainAxisAlignment: width>=1024?MainAxisAlignment.center:MainAxisAlignment.start,
                        children: [
                          Text("+91"),SizedBox(width: width>=600?1.w:5.w,),
                          if (width >= 1024)
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 320), // 1024px+ par max 320px hi width lega
                              child: TextfieldWidget(
                                controller: mobileController,
                                keyboardType: TextInputType.phone,
                                validator: Validators.phone,
                                label: "Mobile Number",
                              ),
                            )
                          else
                            Expanded(
                              child: TextfieldWidget(
                                controller: mobileController,
                                keyboardType: TextInputType.phone,
                                validator: Validators.phone,
                                label: "Mobile Number",
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 2.h,),
                      FractionallySizedBox(
                        widthFactor: width>=1024?0.5:1.0,
                        child: Obx(
                          ()=>authController.loading.value?
                              Center(
                                child: CircularProgressIndicator(color: Colors.red,),
                              )
                              :

                          CommonButtonWidget(btnName: 'Send   OTP', btnText: Colors.white, callback:(){

                            if(_formKey.currentState!.validate()){
                              authController.sendOtp(mobile: mobileController.text);

                            }

                          },btnBgColor:AppColores.custtombtnColor,),
                        ),
                      ),
                      SizedBox(height: 2.h,),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Don`t have an account?",
                              style: Appthemestyle.poppins(color: Color(0xff707070),fontSize: 14.sp.clamp(14.0, 20.0)),
                            ),
                
                            TextSpan(
                              text: "sign up",
                              style: Appthemestyle.poppins(color: AppColores.custtombtnColor,fontSize: 14.sp.clamp(14.0, 20.0)),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(() => SignupScreen());
                                },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
