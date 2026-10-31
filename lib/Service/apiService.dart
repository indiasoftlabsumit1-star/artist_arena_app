



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
import 'package:artist_arena_app/Models/storySeenModel.dart';
import 'package:artist_arena_app/Models/verifyOTP.dart';
import 'package:artist_arena_app/Service/apiUrl.dart';
import 'package:http/http.dart' as http;

import '../Models/createStoryModel.dart';
import '../Models/storyModel.dart';
import '../Models/storyViewModel.dart';
import '../Models/uploadModel.dart';
import 'apiException.dart';

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


    if(response.statusCode==200||response.statusCode==201){
      final data=jsonDecode(response.body);

      return    SignupModel.fromJson(data);
    }
    else{
      _throwApiError(response);
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

  if(response.statusCode==200){
    final data= jsonDecode(response.body);

    return  SendOtpModel.fromJson(data);
  }
  else{
    _throwApiError(response);
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


  if(response.statusCode==200){
    final data =jsonDecode(response.body);

    return VerifyOtpModel.fromJson(data);
  }
  else{
    _throwApiError(response);
  }
 }
Future<bool> logOut(String token) async {
  final response = await http.post(
    Uri.parse(Apiurl.logOut),
    headers: {
      "Accept": "application/json",
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    _throwApiError(response);
  }
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
  if(response.statusCode==200){
    final data=jsonDecode(response.body);

    return ProfileModel.fromJson(data);

  }else{
    _throwApiError(response);
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


  if (response.statusCode == 200 || response.statusCode == 201) {
    final data = jsonDecode(response.body);

    return UploadFileModel.fromJson(data);
  } else {
    _throwApiError(response);
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


  if (response.statusCode == 200 ||
      response.statusCode == 201) {
    final data = jsonDecode(response.body);

    return UploadFileModel.fromJson(data);
  } else {
    _throwApiError(response);

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


  if (response.statusCode == 200 ||
      response.statusCode == 201) {
    final data = jsonDecode(response.body);

    return UploadFileModel.fromJson(data);
  } else {
    _throwApiError(response);

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

  if(response.statusCode==200){
    final data=jsonDecode(response.body);

    return ProfileData.fromJson(data);
  }
  else
    {
      _throwApiError(response);
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

  if(response.statusCode==200){
    final data=jsonDecode(response.body);

    return   SendOtpModel.fromJson(data);
  }
  else{
    _throwApiError(response);
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

    if(response.statusCode==200){
      final data=jsonDecode(response.body);

      return  FeedModel.fromJson(data);
    }
    else{
      _throwApiError(response);
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


  if(response.statusCode==200){
    final data=jsonDecode(response.body);

    return CommentListModel.fromJson(data);
  }
  else{
    _throwApiError(response);
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

  if(response.statusCode==200){
    final data=jsonDecode(response.body);

    return LikeListModel.fromJson(data);
  }
  else{
    _throwApiError(response);
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

  if(response.statusCode==200){
    final data=jsonDecode(response.body);

    return LikeModel.fromJson(data);
  }
  else{
    _throwApiError(response);
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


  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    return LikeModel.fromJson(data);
  } else {
    _throwApiError(response);
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

  if(response.statusCode==201){
    final data=jsonDecode(response.body);

    return   AddCommentModel.fromJson(data)    ;
  }else{
    _throwApiError(response);
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


  if(response.statusCode==201){
    final data=jsonDecode(response.body);

    return CreatePostModel.fromJson(data);
  }else{
    _throwApiError(response);
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


  if (response.statusCode == 200 || response.statusCode == 201) {
    final data = jsonDecode(response.body);

    return CreateStoryModel.fromJson(data);
  } else {
    _throwApiError(response);

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


  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    return StoriesRowModel.fromJson(data);
  } else {
    _throwApiError(response);

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

  if(response.statusCode==200||response.statusCode==201){
    final data=jsonDecode(response.body);

    return   MyStoryModel.fromJson(data);
  }else{
    _throwApiError(response);
  }
}


Future<StorySeenModel> storySeen({
  required String token,
  required int storyId,
}) async {
  final response = await http.post(
    Uri.parse(Apiurl.storySeen(storyId)),
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    },
  );

  print("Story seen status code: ${response.statusCode}");
  print("Story seen response: ${response.body}");


  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data['status'] == true) {
      return StorySeenModel.fromJson(data['data']);
    } else {
      _throwApiError(response);
    }
  } else {
    _throwApiError(response);
  }
}


Future<StoryViewModel> storyView({
  required String token,
  required int storyId,
}) async {
  final response = await http.get(
    Uri.parse(Apiurl.storyView(storyId)),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  print('Story viewers status code: ${response.statusCode}');
  print('Story viewers response: ${response.body}');


  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
if(data['status'] == true){
  return StoryViewModel.fromJson(data);

}else{
  _throwApiError(response);

}
  } else {
    _throwApiError(response);

  }
}

Future<void> deleteStory({
  required String token,
  required int storyId,
}) async {
  final response = await http.post(
    Uri.parse(Apiurl.deleteStory(storyId)),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  print('Delete story status: ${response.statusCode}');
  print('Delete story response: ${response.body}');


  if (response.statusCode == 200 ) {

    return;
  } else {
    _throwApiError(response);

  }
}



Never _throwApiError(http.Response response) {
  String message = 'Something went wrong. Please try again.';

  try {
    final data = jsonDecode(response.body);

    if (data is Map<String, dynamic> &&
        data['message'] is String &&
        data['message'].toString().trim().isNotEmpty) {
      message = data['message'];
    }
  } catch (_) {}

  throw ApiException(
    statusCode: response.statusCode,
    message: message,
  );
}
}