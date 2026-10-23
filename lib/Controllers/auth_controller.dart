




import 'dart:async';

import 'package:artist_arena_app/Screens/onbording_screen.dart';
import 'package:artist_arena_app/Screens/otp_screen.dart';
import 'package:artist_arena_app/Service/apiService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../Models/sendOtpModel.dart';
import '../Screens/home_screen.dart';
import '../Screens/login_screen.dart';
import '../Widgets/common_button_widget.dart';

class AuthController extends GetxController{


    final Apiservice apiservice= Apiservice();
    final RxInt remainingSeconds = 0.obs;
    Timer? resendTimer;


    final RxnString selectedCategoryId = RxnString();
    final Rxn<SendOtpModel> resendOtpResponse = Rxn<SendOtpModel>();
Future<void> login()async {
await Future.delayed(Duration(seconds: 5));
final pref=await SharedPreferences.getInstance();
final token=pref.getString('token');

if(token!=null&& token.isNotEmpty){
  Get.off(()=>HomeScreen());

}
else{
  Get.off(()=>OnbordingScreen());

}
}

RxString firstName = ''.obs;
RxString lastName = ''.obs;
RxString email = ''.obs;
RxString mobile = ''.obs;
RxString dob = ''.obs;
RxString state = ''.obs;
RxString city = ''.obs;
RxString category = ''.obs;

RxBool isChecked = false.obs;
void checkboxCheck(bool value){
  isChecked.value=value;
}
    final RxBool loading = false.obs;

    Future<void> signUp({
      required String fName,
      required String lName,
      required String email,
      required String mobile,
      required String dob,
      required String state,
      required String city,
      required String category,
      required bool terms,
    }) async {
      if (loading.value) return;

      loading.value = true;

      try {
        final response = await apiservice.signUp(
          fName: fName,
          lName: lName,
          email: email,
          mobile: mobile,
          dob: dob,
          state: state,
          city: city,
          category: category,
          terms: terms,
        );

         print("Response signup: ${response.message}");

        if (response.status) {
          Get.dialog(
            AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Thanks',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              content: Text(
                "Your account has been successfully created",
                textAlign: TextAlign.center,
              ),
              actions: [
                CommonButtonWidget(
                  btnName: 'Login',
                  btnText: Colors.white,
                  callback: () {
                    Get.to(
                          () => LoginScreen(
                        mobile: response.data?.mobile,
                        otp: response.data?.otp,
                      ),
                    );
                  },
                  btnBgColor: Colors.red,
                ),
              ],
            ),
          );
        } else {
          throw Exception(response.message);
        }
      } catch (e) {
         print("Signup error: $e");

        Get.snackbar(
          'Signup Failed',
          '$e.',
        );
      } finally {
        loading.value = false;
      }
    }

Future<void>  sendOtp({
      required String mobile
})async{

    if(loading.value) return;

    loading.value=true;
    try {



      final response = await apiservice.sendOtp(mobile: mobile);


       print("send otp response : $response");

      if (response.status) {
        startResendTimer(
          response.data?.resendAfterSeconds ?? 0,
        );
        Get.to(() => OtpScreen(mobile: mobile, otp: response.data?.otp,));
      }
      else {
        Get.snackbar("send otp", response.message);
      }
    }catch (e) {
      print("send otp error: $e");

      Get.snackbar(
        'send otp Failed',
        'Something went wrong. Please try again.',
      );
    } finally {
      loading.value = false;
    }
}

Future<void> otpVerify({
      required String mobile,
  required String otp
})async{

  if(loading.value)return;
  loading.value=true;

  try {
    final response = await apiservice.otpVerify(otp: otp, mobile: mobile);

    if(response.data?.token!=null&&response.data!.token.isNotEmpty){
      final pref=await SharedPreferences.getInstance();
      await pref.setString('token', response.data!.token);
      print("token saved success full");
    }

    print("signup otp $response");
    if (response.status) {
      Get.offAll(() => HomeScreen());
    }
    else {
      Get.snackbar("OTP", 'Please Enter Valid OTP');
    }
  }
  catch (e) {
    print("otp verify  error: $e");

    Get.snackbar(
      'otp verify Failed',
      'Something went wrong. Please try again.',
    );
  } finally {
    loading.value = false;
  }
}




Future<bool>  logOut()async{

  if(loading.value) return false;
  loading.value=true;
      try{

        final pref=await SharedPreferences.getInstance();
        final token=pref.getString('token');

        if(token==null||token.isEmpty){
          print("token not found");
          return false;
        }

        final response=await apiservice.logOut(token);

        if(response){
          await pref.remove('token');
          Get.offAll(()=>LoginScreen());
          return true;
        }
      }catch(e){
        print(" logoput error : $e");

        Get.snackbar("log out", "$e");
      }
      finally {
        loading.value = false;
      }
      return false;
}


Future<void> resendOtp(String mobile)async{


      try{

        final response=await apiservice.resendOtp( number: mobile);
        resendOtpResponse.value=response;
        if (response.status) {
          startResendTimer(
            response.data?.resendAfterSeconds ?? 30,
          );
        }
        print("resend otp api response :${response.message}");

      }catch(e){
        print("resend otp api error :$e");
      }
}
// void signup(){
//
// }


  void startResendTimer(int seconds) {
    resendTimer?.cancel();
    remainingSeconds.value = seconds;

    resendTimer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (remainingSeconds.value > 0) {
          remainingSeconds.value--;
        } else {
          timer.cancel();
        }
      },
    );
  }
}