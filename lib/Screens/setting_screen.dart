


import 'dart:io';

import 'package:artist_arena_app/Controllers/auth_controller.dart';
import 'package:artist_arena_app/Controllers/profile_controller.dart';
import 'package:artist_arena_app/Utils/appThemeStyle.dart';
import 'package:artist_arena_app/Widgets/common_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../Utils/validator.dart';
import '../Widgets/textField_widget.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final dobController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final categoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  final profileController=Get.find<ProfileController>();
  final authController=Get.find<AuthController>();

  final ImagePicker picker = ImagePicker();
  final Rx<File?> selectedImage = Rx<File?>(null);

  Future<void> pickAndUploadImage() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return;

    selectedImage.value = File(image.path);

    await profileController.uploadFile(
      selectedImage.value!,
    );
  }
  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    if (profileController.profile.value == null) {
      await profileController.getProfile();
    }

    final profile = profileController.profile.value;

    if (!mounted || profile == null) return;

    fNameController.text = profile.firstName;
    lNameController.text = profile.lastName;
    emailController.text = profile.email;
    mobileController.text = profile.mobile;
    dobController.text = profile.dateOfBirthDisplay;
    stateController.text = profile.state;
    cityController.text = profile.city;
    categoryController.text = profile.category?.name ?? '';
    authController.selectedCategoryId.value =
        (profile.categoryId ?? profile.category?.id)?.toString();
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
      
      body:LayoutBuilder(
        builder: (context, constraints) {
          final double width=constraints.maxWidth;
          return Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 7.w,vertical: 5.h),
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: width>=600?1200:double.infinity
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(width: double.infinity,child: Center(child: Text("Setting",style: Appthemestyle.poppins(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600
                      ),)),),
                      SizedBox(height: 2.h,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x29000000),
                                    offset: Offset(0, 1),
                                    blurRadius: 10,
                                  ),
                                ],
                              color: Colors.white,
                              shape: BoxShape.circle
                            ),
                            child: Obx(
                                  () => GestureDetector(
                                onTap: profileController.profileLoading.value
                                    ? null
                                    : pickAndUploadImage,
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    image: selectedImage.value != null
                                        ? DecorationImage(
                                      image: FileImage(selectedImage.value!),
                                      fit: BoxFit.cover,
                                    )
                                        : null,
                                  ),
                                  child: profileController.profileLoading.value
                                      ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                      : selectedImage.value == null
                                      ? const Icon(Icons.file_upload_outlined)
                                      : null,
                                ),
                              ),
                            ),                        ),
                          SizedBox(width: 5.w,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Text("Upload photo",style: Appthemestyle.poppins(fontSize: 15.sp),),
                            Text("(Jpg or png)",style: Appthemestyle.poppins(fontSize: 15.sp),),
                            Text("Delete",style: Appthemestyle.poppins(color: AppColores.custtombtnColor,fontStyle: FontStyle.italic,fontSize: 15.sp),)
                          ],)
                        ],
                      ),
                      SizedBox(height: 2.h,),

                      if(width>=1024)
                        _buildDesktopFormGrid()
                      else
                        _buildMobileFormColumn(),
                      SizedBox(height: 2.h,),

                      Obx(
                        ()=>profileController.profileLoading.value?CircularProgressIndicator(color: Colors.red,): CommonButtonWidget(btnName: 'Save', btnText: Colors.white,
                                  callback: () {

                                    if (_formKey.currentState?.validate() != true) {
                                      return;
                                    }
                         profileController.updateProfile(
                              fName: fNameController.text.trim(),
                                          lName: lNameController.text.trim(),
                        email: emailController.text.trim(),
                                           dob: dobController.text.trim(),
                                           state: stateController.text.trim(),
                              city: cityController.text.trim(),
                                          category: authController.selectedCategoryId.value!,
                                          avatar: profileController.uploadedAvatarPath ?? '',
                                         );
                                    },
                           btnBgColor: Colors.red,width: width>=1024?500:double.infinity,),
                      ),
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

  Widget _buildDesktopFormGrid() {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 60,
      mainAxisSpacing: 15,
      childAspectRatio: 4.0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        TextfieldWidget(label: 'First Name',controller: fNameController,validator: Validators.name,),
        TextfieldWidget(label: 'Last Name',controller: lNameController,validator: Validators.name,),
        TextfieldWidget(label: 'Email',controller: emailController,validator: Validators.email,),
        TextfieldWidget(label: 'Mobile Number',controller: mobileController,validator: Validators.phone,),
        TextfieldWidget(label: 'Date of Birth',controller: dobController,validator: Validators.dateOfBirth,),
        TextfieldWidget(label: 'State',controller: stateController,validator: Validators.stateRequired,),
        TextfieldWidget(label: 'City',controller: cityController,validator: Validators.cityRequired,),
        Obx(
              () => CategoryDropdownWidget(
            value: authController.selectedCategoryId.value,
            onChanged: (value) {
              authController.selectedCategoryId.value = value;
            },
            validator: Validators.categoryRequired,
          ),
        ),        ],
    );
  }


// Mobile Single Column Layout
  Widget _buildMobileFormColumn() {
    return Column(
      children: [
        TextfieldWidget(label: 'First Name',controller: fNameController,validator: Validators.name,),
        SizedBox(height: 2.h,),
        TextfieldWidget(label: 'Last Name',controller: lNameController,validator: Validators.name,),
        SizedBox(height: 2.h,),
        TextfieldWidget(label: 'Email',controller: emailController,validator: Validators.email,),
        SizedBox(height: 2.h,),
        TextfieldWidget(label: 'Mobile Number',controller: mobileController,validator: Validators.phone,),
        SizedBox(height: 2.h,),
        TextfieldWidget(label: 'Date of Birth',controller: dobController,validator: Validators.dateOfBirth,),
        SizedBox(height: 2.h,),
        TextfieldWidget(label: 'State',controller: stateController,validator: Validators.stateRequired,),
        SizedBox(height: 2.h,),
        TextfieldWidget(label: 'City',controller: cityController,validator: Validators.cityRequired,),
        SizedBox(height: 2.h,),
        Obx(
              () => CategoryDropdownWidget(
            value: authController.selectedCategoryId.value,
            onChanged: (value) {
              authController.selectedCategoryId.value = value;
            },
            validator: Validators.categoryRequired,
          ),
        ),        ],
    );
  }
}
