



import 'dart:io';

import 'package:artist_arena_app/Models/profileModel.dart';
import 'package:artist_arena_app/Service/apiService.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController{

  RxInt selectedIndex = 0.obs;
Rx<ProfileData?> profile=Rx<ProfileData?>(null);



    final RxBool profileLoading=false.obs;

final Apiservice apiservice=Apiservice();
  void changeTab(int index) {
    selectedIndex.value = index;
  }


  Future<void>  getProfile()async{

    try{

      profileLoading.value=true;
      final pref=await SharedPreferences.getInstance();
      final token=pref.getString('token');

      if(token==null||token.isEmpty){
        print("token not found");
        return;
      }

      final response=await apiservice.getProfile(token);
      profile.value=response.data;

      print("profile api response  :$response");
    }
    catch(e){
      print("profile pai error : $e");
    }finally{
      profileLoading.value=false;
    }
  }

  String? uploadedAvatarPath;

  Future<void> uploadFile(File file) async {
    try {
      profileLoading.value = true;

      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');

      if (token == null || token.isEmpty) {
        print("token not found");
        return;
      }

      final response = await apiservice.uploadFile(token, file);

      if (response.success && response.data != null) {
        uploadedAvatarPath = response.data!.path;

        print("Uploaded image path: $uploadedAvatarPath");
        print("Image URL: ${response.data!.url}");
      } else {
        print("File upload failed: ${response.message}");
      }
    } catch (e) {
      print("Upload API error: $e");
    } finally {
      profileLoading.value = false;
    }
  }


  Future<void> updateProfile({
    required String fName,
    required String lName,
    required String email,
    required String dob,
    required String state,
    required String city,
    required String category,
    required  String  avatar,
})async{


    try{
      profileLoading.value=true;
      final pref=await SharedPreferences.getInstance();
      final token=pref.getString('token');
      if(token==null||token.isEmpty){
        print("token not found");
        return;
      }
      final response=await apiservice.updateProfile(fName: fName, lName: lName,
          email: email, dob: dob,
          state: state, city: city,
          category: category,
          avatar: avatar, token: token
      );

      profile.value=response;
      print("update profile response : $response");

      getProfile();

      Get.snackbar(
        'Success',
        'Profile updated successfully',
      );

    }catch(e){
      print("update profiule error : $e");
    }
    finally{
      profileLoading.value=false;

    }
  }




}