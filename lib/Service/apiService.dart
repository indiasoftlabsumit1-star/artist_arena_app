



import 'dart:convert';
import 'dart:io';

import 'package:artist_arena_app/Models/profileModel.dart';
import 'package:artist_arena_app/Models/sendOtpModel.dart';
import 'package:artist_arena_app/Models/signUpModel.dart';
import 'package:artist_arena_app/Models/verifyOTP.dart';
import 'package:artist_arena_app/Service/apiUrl.dart';
import 'package:http/http.dart' as http;

import '../Models/uploadModel.dart';

class Apiservice {




Future<SignupModel>  signUp({
 required String fName,
  required String lName,
  required String email,
  required String mobile,
  required String dob,
  required String state,
  required String city,
  required String category,
  required bool terms
})async{

    final response=await http.post(Uri.parse(Apiurl.signUp),

    body: jsonEncode({
      "first_name": fName,
      "last_name":lName,
      "email":email,
      "mobile":mobile,
      "date_of_birth":dob,
      "state":state,
      "city":city,
      "category_id":category,
      "terms_accepted":terms,
    }),
      headers: {
      "Accept":"application/json",
        "Content-Type":"application/json"
      }
    );
    //
    // print("signup api response status code : ${response.statusCode}");
    // print("signup api response body : ${response.body}");

    final data=jsonDecode(response.body);

    if(response.statusCode==200||response.statusCode==201){
      return    SignupModel.fromJson(data);
    }
    else{
      throw Exception(data['message']??"failed to  signup");
    }
}


Future<SendOtpModel>  sendOtp({
  required String mobile
})async{

  final  response=await http.post(Uri.parse(Apiurl.sendOtp),

  body: jsonEncode({
    "mobile":mobile
  }),
      headers: {
        "Accept":"application/json",
        "Content-Type":"application/json"
      }

  );
  //
  // print("  send otp api status code : ${response.statusCode}");
  // print("send otp api response body : ${response.body}");

  final data= jsonDecode(response.body);
  if(response.statusCode==200){
    return  SendOtpModel.fromJson(data);
  }
  else{
    throw Exception(data['message']??"failed to send otp ");
  }
}

 Future<VerifyOtpModel>  otpVerify({
  required String otp,
   required String mobile,
})async{
  
  final response=await http.post(Uri.parse(Apiurl.signupOTP),
     body: jsonEncode({
       "mobile":mobile,
       "otp":otp,
       "device_id":'1',
       "device_type":"android"
     }),
      headers: {
        "Accept":"application/json",
        "Content-Type":"application/json"
      }
  );
  //
  // print("singup ot verify api status code : ${response.statusCode}");
  // print("signup otp verify api response body : ${response.body}");

  final data =jsonDecode(response.body);

  if(response.statusCode==200){
    return VerifyOtpModel.fromJson(data);
  }
  else{
    throw Exception(data["message"]??"failed to verify otp");
  }
 }

 Future<bool>  logOut(String token)async{
  
  final response=await http.post(Uri.parse(Apiurl.logOut),
      headers: {
        "Accept":"application/json",
        'Authorization': 'Bearer $token',

      }
  );

  print("log out resposne :${response.statusCode}");
  print("log out response body : ${response.body}");

  // final data =jsonDecode(response.body);
  return response.statusCode==200;
 }



 Future<ProfileModel> getProfile(String token)async{

  final response=await http.get(Uri.parse(Apiurl.profile),

  headers: {
    "Accept":"application/json",
    'Authorization': 'Bearer $token',
  }
  );

  print("profile api response status code : ${response.statusCode}");
  print("profile api response body : ${response.body}");
  final data=jsonDecode(response.body);
  if(response.statusCode==200){
    return ProfileModel.fromJson(data);

  }else{
    throw Exception(data["message"]??"failed to load profile api ");
  }
 }


Future<UploadFileModel> uploadFile(String token, File file) async {
  final request = http.MultipartRequest(
    'POST',
    Uri.parse(Apiurl.upload),
  );

  request.headers.addAll({
    "Accept": "application/json",
    "Authorization": "Bearer $token",
  });

  request.fields['folder'] = 'avatars';

  request.files.add(
    await http.MultipartFile.fromPath(
      'file',
      file.path,
    ),
  );

  final streamedResponse = await request.send();
  final response = await http.Response.fromStream(streamedResponse);

  print("Upload API status code: ${response.statusCode}");
  print("Upload API response body: ${response.body}");

  final data = jsonDecode(response.body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    return UploadFileModel.fromJson(data);
  } else {
    throw Exception(data["message"] ?? "Failed to upload file");
  }
}
Future<ProfileData> updateProfile({
  required String fName,
  required String lName,
  required String email,
  required String dob,
  required String state,
  required String city,
  required String category,
  required  String  avatar,
  required String token
})async{

  final response=await http.post(Uri.parse(Apiurl.update),

  body: jsonEncode({
    "first_name":fName,
    "last_name":lName,
    "email":email,
    "date_of_birth":dob,
    "state":state,
    "city":city,
    "category_id":category,
    "avatar":avatar
  }),
    headers: {
      "Accept":"application/json",
      "Content-Type":"application/json",
      "Authorization": "Bearer $token",

    }
  );

  print("   upadte p[rofile api response status code  : ${response.statusCode}");
  print("update   profile api   response body : ${response.body}");

  final data=jsonDecode(response.body);
  if(response.statusCode==200){
    return ProfileData.fromJson(data);
  }
  else
    {
      throw Exception(data['message']?? "failed to update profile ");
    }
}



Future<SendOtpModel> resendOtp({

  required String number
})async{
  
  final response=await http.post(Uri.parse(Apiurl.resendOtp),

  body: jsonEncode({
    "mobile":number
  }),


      headers: {
        "Accept":"application/json",
        "Content-Type":"application/json",


      }
  );
  print(" resend otp api response status code :${response.statusCode}");
  print("resend otp api response body : ${response.body}");

  final data=jsonDecode(response.body);
  if(response.statusCode==200){
    return   SendOtpModel.fromJson(data);
  }
  else{
    throw Exception(data['message']??"failed to resend the otp");
  }
}

}