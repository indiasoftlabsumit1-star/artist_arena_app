



import 'package:artist_arena_app/Controllers/auth_controller.dart';
import 'package:artist_arena_app/Screens/signup_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../Utils/appThemeStyle.dart';
import '../Widgets/common_button_widget.dart';
import '../Widgets/textField_widget.dart';

class OtpScreen extends StatefulWidget {

  final String mobile;
  final    String? otp;
  const OtpScreen({super.key, required this.mobile,  this.otp});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final otpController=TextEditingController();
  final _formKey = GlobalKey<FormState>();
final authController=Get.find<AuthController>();
  @override
  void dispose() {
    // TODO: implement dispose

    otpController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:  LayoutBuilder(
        builder: (context, constraints) {

        final double width=constraints.maxWidth;
        final double height = constraints.maxHeight;

        bool landescape = width>height&&height<500;
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: width >= 1024 ?width*0.85 :landescape?width*0.85: double.infinity,
              ),
              child: SingleChildScrollView(
                child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 7.w),
                
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
                           child: Image.asset("assets/images/loginimg.png")),
                      Text("OTP Has Been Sent To",style: Appthemestyle.poppins(fontSize: 20.sp.clamp(18.0, 25.0),fontWeight: FontWeight.w600)),
                      SizedBox(height: 2.h,),
                      Text("+91 ${widget.mobile}",style: Appthemestyle.poppins(fontSize: 14.sp.clamp(18.0, 20),color: Color(0xff707070),height: 0.5)),
                      SizedBox(height: 2.h,),
                      Text("${widget.otp}",style: Appthemestyle.poppins(fontSize: 14.sp.clamp(18.0, 20),color: Color(0xff707070),height: 0.5)),
                      SizedBox(height: 2.h,),

                      Row(
                        mainAxisAlignment: width>=1024?MainAxisAlignment.center:MainAxisAlignment.start,
                
                        children: [
                          Text("+91"),SizedBox(width: width>=600?1.w:5.w,),
                
                          if(width>=1024)
                
                            ConstrainedBox(constraints: BoxConstraints(maxWidth: 320),child:
                
                             TextfieldWidget(controller: otpController,
                                keyboardType: TextInputType.number,
                                label: 'OTP',
                              ),
                            )
                          else
                          Expanded(
                            child: TextfieldWidget(controller: otpController,
                              keyboardType: TextInputType.phone,
                              label: 'OTP',
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 2.h,),
                      Obx(() {
                        final canResend = authController.remainingSeconds.value == 0;

                        return TextButton(
                          onPressed: canResend
                              ? () {
                           authController.resendOtp(widget.mobile);
                          }
                              : null,
                          child: Text(
                            canResend
                                ? "Resend"
                                : "Resend in ${authController.remainingSeconds.value}s",
                            style: TextStyle(
                              color: canResend ? Colors.red : Colors.grey,
                            ),
                          ),
                        );
                      }),
                
                      FractionallySizedBox(
                        widthFactor: width>=1024?0.5:1.0,
                        child: Obx(
                          ()=> authController.loading.value?
                              Center(
                                child: CircularProgressIndicator(color: Colors.red,),
                              )
                              :

                          CommonButtonWidget(btnName: 'Verify', btnText: Colors.white, callback:(){

                            authController.otpVerify(mobile: widget.mobile, otp: otpController.text);
                          },btnBgColor: AppColores.custtombtnColor,),
                        ),
                      ),
                      SizedBox(height: 2.h,),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Don`t have an account?",
                                style: Appthemestyle.poppins(color: Color(0xff707070),fontSize: 14.sp.clamp(14.0, 20.0))
                            ),
                
                            TextSpan(
                              text: "sign up",
                              style: Appthemestyle.poppins(color: AppColores.custtombtnColor,fontSize: 14.sp.clamp(14.0, 20.0)),                    recognizer: TapGestureRecognizer()
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
