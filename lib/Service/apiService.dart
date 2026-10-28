



import 'dart:convert';
import 'dart:io';

import 'package:artist_arena_app/Models/addCommentModel.dart';
import 'package:artist_arena_app/Models/commentModel.dart';
import 'package:artist_arena_app/Models/favModel.dart';
import 'package:artist_arena_app/Models/feedModel.dart';
import 'package:artist_arena_app/Models/likeModel,dart.dart';
import 'package:artist_arena_app/Models/myStoryModel.dart';
import 'package:artist_arena_app/Models/profileModel.dart';
import 'package:artist_arena_app/Models/sendOtpModel.dart';
import 'package:artist_arena_app/Models/signUpModel.dart';
import 'package:artist_arena_app/Models/verifyOTP.dart';
import 'package:artist_arena_app/Service/apiUrl.dart';
import 'package:http/http.dart' as http;

import '../Models/createStoryModel.dart';
import '../Models/storyModel.dart';
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

Future<UploadFileModel> uploadPostMedia(
    String token,
    File file,
    ) async {
  final request = http.MultipartRequest(
    'POST',
    Uri.parse(Apiurl.upload),
  );

  request.headers.addAll({
    "Accept": "application/json",
    "Authorization": "Bearer $token",
  });

  request.fields['folder'] = 'posts';

  request.files.add(
    await http.MultipartFile.fromPath(
      'file',
      file.path,
    ),
  );

  final streamedResponse = await request.send();
  final response = await http.Response.fromStream(
    streamedResponse,
  );

  print("Post media upload status: ${response.statusCode}");
  print("Post media upload body: ${response.body}");

  final data = jsonDecode(response.body);

  if (response.statusCode == 200 ||
      response.statusCode == 201) {
    return UploadFileModel.fromJson(data);
  } else {
    throw Exception(
      data["message"] ?? "Failed to upload post media",
    );
  }
}

Future<UploadFileModel>  storyUpload({
 required String token,
      required File file
})async{

  final  request=http.MultipartRequest('POST',Uri.parse( Apiurl.upload),

  );
  request.headers.addAll({
    "Accept": "application/json",
    "Authorization": "Bearer $token",
  });
  request.fields['folder'] = 'stories';

  request.files.add(
    await http.MultipartFile.fromPath(
      'file',
      file.path,
    ),
  );

  final streamedResponse = await request.send();
  final response = await http.Response.fromStream(
    streamedResponse,
  );

  print("story upload status: ${response.statusCode}");
  print(" story media upload body: ${response.body}");

  final data = jsonDecode(response.body);

  if (response.statusCode == 200 ||
      response.statusCode == 201) {
    return UploadFileModel.fromJson(data);
  } else {
    throw Exception(
      data["message"] ?? "Failed to upload story media",
    );
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

  Future<FeedModel>  getFeed({
  int page=1,
    int followingOnly=0,
    int perPage=10,
    String sort='recent',

    required String token
})async
  {

    final uri=  Uri.parse(Apiurl.feed).replace(
      queryParameters: {
        'sort':sort,
        'following_only':followingOnly.toString(),
        'per_page':perPage.toString(),
        'page':page.toString()
      }
    );

    final response =await http.get(uri,
    headers: {
      "Accept":"application/json",
      "Authorization": "Bearer $token",
    }
    );

    print('feed api response status code : ${response.statusCode}');
    print('feed api response body : ${response.body}');

    final data=jsonDecode(response.body);
    if(response.statusCode==200){
      return  FeedModel.fromJson(data);
    }
    else{
      throw Exception(data['message']??'failed to load feed api ');
    }
  }

  Future<CommentListModel> getComment({
  required String token,
    required int postId,
    int page=1,

  })async{


  final uri=Uri.parse(Apiurl.comment(postId)).replace(
    queryParameters: {
      'page':page.toString()
    }
  );

  final response=await http.get(uri,

  headers: {
    "Accept":"application/json",
    "Authorization": "Bearer $token",
  }
  );

  print("comment api response api status code : ${response.statusCode}");
  print("comment api response  body :${response.body}");


  final data=jsonDecode(response.body);
  if(response.statusCode==200){
    return CommentListModel.fromJson(data);
  }
  else{
    throw Exception(data['message']??'failed to load a comment');
  }
  }


  Future<LikeListModel>  getLikes({
  required String token,
  required int postId,
    int page=1
})async{

  final uri= Uri.parse(Apiurl.likes(postId)).replace(
    queryParameters: {
      'page':page.toString()
    }
  );

  final response=await http.get(uri,

  headers: {
    "Accept":"application/json",
    "Authorization": "Bearer $token",
  }
  );

  print(" likes api response status code :${response.statusCode}");
  print('likes api response body : ${response.body}');

  final data=jsonDecode(response.body);
  if(response.statusCode==200){
    return LikeListModel.fromJson(data);
  }
  else{
    throw Exception(data['message']??'failed to load a likes');
  }
  }


  Future<LikeModel>  like({
  required String token,
    required int postId
})async{
     
  final response=await http.post(Uri.parse(Apiurl.like(postId)),
  headers: {
    "Accept":"application/json",
    "Authorization": "Bearer $token",
  }
  );
  
  
  print("like api response status code   : ${response.statusCode}");
  print("like api response body : ${response.body}");

  final data=jsonDecode(response.body);
  if(response.statusCode==200){
    return LikeModel.fromJson(data);
  }
  else{
    throw Exception(data['message']??'failed to like post');
  }
  }

Future<LikeModel> unLike({
  required String token,
  required int postId,
}) async {
  final response = await http.post(
    Uri.parse(Apiurl.unLike(postId)),
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    },
  );

  print('Unlike API status code: ${response.statusCode}');
  print('Unlike API response body: ${response.body}');

  final data = jsonDecode(response.body);

  if (response.statusCode == 200) {
    return LikeModel.fromJson(data);
  } else {
    throw Exception(data['message'] ?? 'Failed to remove like');
  }
}
Future<AddCommentModel>   addComment({
  required String token,
  required String comment,
  required int postId,
})async{

  final response=await http.post(Uri.parse(Apiurl.addComment(postId)),

  body: jsonEncode({
    'comment':comment
  }),
    headers: {
      "Accept":"application/json",
      "Content-Type":"application/json",
      "Authorization": "Bearer $token",
    }
  );
  print("add comment api response status code :${response.statusCode}");
  print("add comment api response body  :${response.body}");
  final data=jsonDecode(response.body);

  if(response.statusCode==201){
    return   AddCommentModel.fromJson(data)    ;
  }else{
    throw Exception(data['message']??'failed to add comment');
  }
}



Future<CreatePostModel> post({
  required String token,
  required String caption,
  required List<String> media
})async{

  final response=await http.post(Uri.parse(Apiurl.post),
    body: jsonEncode({
      'caption':caption,
      'media':media
    }),
    headers: {
      "Accept":"application/json",
      "Content-Type":"application/json",
      "Authorization": "Bearer $token",
    }
  ) ;

  print(" post api response status code : ${response.statusCode}");
  print("post api response body :${response.body}");

  final data=jsonDecode(response.body);

  if(response.statusCode==201){
    return CreatePostModel.fromJson(data);
  }else{
    throw Exception(data['message']??'failed to post');
  }

}



Future<CreateStoryModel> createStory({
  required String token,
  required String media,
   String caption='Good vibes only ✨',
}) async {
  final response = await http.post(
    Uri.parse(Apiurl.createStory),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
    body: jsonEncode({
      "media": media,
      "caption": caption,
    }),
  );

  print("Create story status: ${response.statusCode}");
  print("Create story response: ${response.body}");

  final data = jsonDecode(response.body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    return CreateStoryModel.fromJson(data);
  } else {
    throw Exception(
      data["message"] ?? "Failed to create story",
    );
  }
}

Future<StoriesRowModel> getStories({
  required String token,
   int followingOnly=0,
}) async {
  final uri = Uri.parse(Apiurl.stories).replace(
    queryParameters: {
      'following_only': followingOnly.toString(),
    },
  );

  final response = await http.get(
    uri,
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    },
  );

  print("Stories row status: ${response.statusCode}");
  print("Stories row response: ${response.body}");

  final data = jsonDecode(response.body);

  if (response.statusCode == 200) {
    return StoriesRowModel.fromJson(data);
  } else {
    throw Exception(
      data["message"] ?? "Failed to fetch stories",
    );
  }
}

Future<MyStoryModel> myAStory(String token)async{


  final response=await http.get(Uri.parse(Apiurl.myStories),
  headers: {
    "Accept": "application/json",
    "Authorization": "Bearer $token",
  }

  );

  print('my story api response status code :${response.statusCode}');
  print('my story api response body :${response.body}');

  final data=jsonDecode(response.body);
  if(response.statusCode==200||response.statusCode==201){
    return   MyStoryModel.fromJson(data);
  }else{
    throw Exception(data['message']??'fiald to load my story ');
  }
}

}