

import 'package:artist_arena_app/Controllers/auth_controller.dart';
import 'package:artist_arena_app/Screens/privecyPolicy_screen.dart';
import 'package:artist_arena_app/Screens/termCondition_screen.dart';
import 'package:artist_arena_app/Utils/validator.dart';
import 'package:artist_arena_app/Widgets/common_button_widget.dart';
import 'package:artist_arena_app/Widgets/textField_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../Utils/appThemeStyle.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

AuthController authController=Get.find<AuthController>();

final fNameController=TextEditingController();
final lNameController=TextEditingController();
final emailController=TextEditingController();
final mobileController=TextEditingController();
final dobController=TextEditingController();
final stateController=TextEditingController();
final cityController=TextEditingController();
final categoryController=TextEditingController();
final _formKey = GlobalKey<FormState>();

@override
void initState() {
  super.initState();
  authController.selectedCategoryId.value = null;
  authController.isChecked.value = false;
}

@override
  void dispose() {
    // TODO: implement dispose
  fNameController.dispose();
  lNameController.dispose();
  emailController.dispose();
  mobileController.dispose();
  dobController.dispose();
  stateController.dispose();
cityController.dispose();
categoryController.dispose();
    super.dispose();
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {

        final double width=constraints.maxWidth;
        final double height=constraints.maxHeight;

        final bool landescape = height < 500 && width > height;

        return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: width >= 1024 ?width*0.85 :landescape?width*0.85: double.infinity,

              ),
              child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 7.w,vertical: 5.h),

              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: SingleChildScrollView(
                  child: Column(

                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Center(child: Text('Sign Up',style: Appthemestyle.poppins(fontWeight: FontWeight.w600,fontSize: 20.sp),),),
                      ),
                      SizedBox(height: 2.h,),
                           if(width>=1024)
                             _buildDesktopFormGrid()
                           else
                             _buildMobileFormColumn(),

                      // TextfieldWidget(label: 'First Name',controller: fNameController,validator: Validators.name,),
                      // SizedBox(height: 2.h,),
                      // TextfieldWidget(label: 'Last Name',controller: lNameController,validator: Validators.name,),
                      // SizedBox(height: 2.h,),
                      // TextfieldWidget(label: 'Email',controller: emailController,validator: Validators.email,),
                      // SizedBox(height: 2.h,),
                      // TextfieldWidget(label: 'Mobile Number',controller: mobileController,validator: Validators.phone,),
                      // SizedBox(height: 2.h,),
                      // TextfieldWidget(label: 'Date of Birth',controller: dobController,validator: Validators.dateOfBirth,),
                      // SizedBox(height: 2.h,),
                      // TextfieldWidget(label: 'State',controller: stateController,validator: Validators.stateRequired,),
                      // SizedBox(height: 2.h,),
                      // TextfieldWidget(label: 'City',controller: cityController,validator: Validators.cityRequired,),
                      // SizedBox(height: 2.h,),
                      // TextfieldWidget(label: 'Category',controller: categoryController,validator: Validators.categoryRequired,),
                      SizedBox(height: 2.h,),
                      Obx(() {
                        return Row(

                          children: [

                            Transform.scale(
                              scale: 5.sp.clamp(1, 1),
                              child: Checkbox(
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  value: authController.isChecked.value,

                                  shape: RoundedRectangleBorder(),
                                  activeColor: Colors.red
                                  ,
                                  checkColor: Colors.white
                                  ,onChanged: (value){
                                authController.isChecked.value=value!;
                              }
                              ),
                            ),SizedBox(width: 3.w.clamp(3, 10),),

                            Expanded(
                              child: RichText(

                                  text: TextSpan(

                                  children: [
                                    TextSpan(
                                        text: "I have read and  agree to the",
                                        style: Appthemestyle.poppins(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontSize: 14.sp.clamp(14.0, 15.0))

                                    ),
                                    WidgetSpan(child: SizedBox(width: 2.w.clamp(2, 5),)),
                                    TextSpan(
                                        text: "Terms and condition",
                                        style: Appthemestyle.poppins(
                                            fontWeight: FontWeight.w400,
                                            color: AppColores.custtombtnColor,
                                            fontSize: 14.sp.clamp(14.0, 15.0)),recognizer: TapGestureRecognizer()
                                        ..onTap=(){
                                          Get.to(()=>TermconditionScreen());
                                    }
                                    ),
                                    WidgetSpan(child: SizedBox(width: 2.w.clamp(2, 5),)),

                                    TextSpan(
                                        text: "and",
                                        style: Appthemestyle.poppins(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontSize: 14.sp.clamp(14.0, 15.0))
                                    ),
                                    WidgetSpan(child: SizedBox(width: 2.w.clamp(2, 5),)),

                                    TextSpan(
                                        text: "Privacy Policy",
                                        style: Appthemestyle.poppins(
                                            fontWeight: FontWeight.w400,
                                            color: AppColores.custtombtnColor,
                                            fontSize: 14.sp.clamp(14.0, 15.0),),recognizer: TapGestureRecognizer()
                                        ..onTap=(){
                                          Get.to(()=>PrivecypolicyScreen());
                                        }
                                    )
                                  ])),
                            )
                          ],
                        );

                      }
                      ),
                      SizedBox(height: 2.h,),
                      FractionallySizedBox(
                        widthFactor: width>=1024?0.2:1.0,
                        child: Obx(
                            ()=> authController.loading.value?
                            Center(child:
                              CircularProgressIndicator(color: Colors.red,),)
                            :CommonButtonWidget(btnName: 'Signup', btnText: Colors.white, callback: (){

                            if (_formKey.currentState!.validate() &&
                                authController.isChecked.value) {
                          
                              authController.firstName.value = fNameController.text;
                              authController.lastName.value = lNameController.text;
                              authController.email.value = emailController.text;
                              authController.mobile.value = mobileController.text;
                              authController.dob.value = dobController.text;
                              authController.state.value = stateController.text;
                              authController.city.value = cityController.text;
                              authController.category.value = categoryController.text;
                          
                              authController.signUp(fName: fNameController.text, lName: lNameController.text,
                                  email: emailController.text, mobile: mobileController.text,
                                  dob: dobController.text, state: stateController.text, city: cityController.text,
                                  category: authController.selectedCategoryId.value!, terms: authController.isChecked.value);
                              // _showSuccessDialog();
                            }
                          },btnBgColor: Colors.red,),
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

// void _showSuccessDialog() {
//   Get.dialog(
//     AlertDialog(
//       title: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           const Icon(Icons.check_circle_outline, color: Colors.green),
//           SizedBox(height: 2.h),
//           Text(
//             'Thanks',
//             style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
//           ),
//         ],
//       ),
//       content: const Text(
//         "Your account has been successfully created",
//         textAlign: TextAlign.center,
//       ),
//       actions: [
//         CommonButtonWidget(
//           btnName: 'Login',
//           btnText: Colors.white,
//           btnBgColor: Colors.red,
//           callback: () {
//             Get.to(() => LoginScreen());
//           },
//         ),
//       ],
//     ),
//   );
// }

Widget _buildDesktopFormGrid() {
  return GridView.count(
    crossAxisCount: 3,
    crossAxisSpacing: 60,
    mainAxisSpacing: 15,
    childAspectRatio: 4.0,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    children: [
      TextfieldWidget(label: 'First Name', controller: fNameController, validator: Validators.name),
      TextfieldWidget(label: 'Last Name', controller: lNameController, validator: Validators.name),
      TextfieldWidget(label: 'Email', controller: emailController, validator: Validators.email),
      TextfieldWidget(label: 'Mobile Number', controller: mobileController, validator: Validators.phone),
      TextfieldWidget(label: 'Date of Birth', controller: dobController, validator: Validators.dateOfBirth),
      TextfieldWidget(label: 'State', controller: stateController, validator: Validators.stateRequired),
      TextfieldWidget(label: 'City', controller: cityController, validator: Validators.cityRequired),
      Obx(
            () => CategoryDropdownWidget(
          value: authController.selectedCategoryId.value,
          onChanged: (value) {
            authController.selectedCategoryId.value = value;
          },
          validator: Validators.categoryRequired,
        ),
      ),    ],
  );
}


// Mobile Single Column Layout
  Widget _buildMobileFormColumn() {
    return Column(
      children: [
        TextfieldWidget(label: 'First Name', controller: fNameController, validator: Validators.name),
        SizedBox(height: 2.h),
        TextfieldWidget(label: 'Last Name', controller: lNameController, validator: Validators.name),
        SizedBox(height: 2.h),
        TextfieldWidget(label: 'Email', controller: emailController, validator: Validators.email),
        SizedBox(height: 2.h),
        TextfieldWidget(label: 'Mobile Number', controller: mobileController, validator: Validators.phone),
        SizedBox(height: 2.h),
        TextfieldWidget(label: 'Date of Birth', controller: dobController, validator: Validators.dateOfBirth),
        SizedBox(height: 2.h),
        TextfieldWidget(label: 'State', controller: stateController, validator: Validators.stateRequired),
        SizedBox(height: 2.h),
        TextfieldWidget(label: 'City', controller: cityController, validator: Validators.cityRequired),
        SizedBox(height: 2.h),
        Obx(
              () => CategoryDropdownWidget(
            value: authController.selectedCategoryId.value,
            onChanged: (value) {
              authController.selectedCategoryId.value = value;
            },
            validator: Validators.categoryRequired,
          ),
        ),    ],
    );
  }
}
