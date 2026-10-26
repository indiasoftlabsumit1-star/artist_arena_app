




import 'dart:io';

import 'package:artist_arena_app/Controllers/profile_controller.dart';
import 'package:artist_arena_app/Models/commentModel.dart';
import 'package:artist_arena_app/Models/likeModel,dart.dart';
import 'package:artist_arena_app/Service/apiService.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/feedModel.dart';

class FeedController extends GetxController{

  CameraController? cameraController;

  final Apiservice apiservice = Apiservice();

  final RxList<FeedItem> feedList = <FeedItem>[].obs;

  final RxList<CommentItem> commentList=<CommentItem>[].obs;
final RxList<LikeItem>  likeItem=<LikeItem>[].obs;
  final RxBool loading= false.obs;
  final profileController=Get.find<ProfileController>();

  Future<void>  getFeed()async{

    try{
      final pref=await SharedPreferences.getInstance();
      final token=pref.getString('token');

      if(token==null||token.isEmpty){
        print("token not found ");
        return;
      }
      final response=await apiservice.getFeed(token: token);
feedList.value=response.data.items;
print("response fedd apiu  :$response");
    }
    catch(e){
      print(e);
    }

  }


  Future<void> getComment(int postId)async{


    try{
     loading.value=true;
      final pref=await SharedPreferences.getInstance();
      final token=pref.getString('token');

      if(token==null||token.isEmpty){
        print("token not found");
        return ;
      }

      final response=await apiservice.getComment(token: token, postId: postId);
      commentList.value=response.data.items;
      print(" response comment :  $response");
    }catch(e){
      print("comment api error : $e");
    }
    finally{
      loading.value=false;
    }
  }


  Future<void> getLikes(int postId)async{


    try{
      loading.value=true;

      final pref=await SharedPreferences.getInstance();
      final token=pref.getString('token');

      if(token==null||token.isEmpty){
        print("token not found");
        return;
      }

      final response=await apiservice.getLikes(token: token, postId: postId);
      likeItem.value=response.data.items;
      print('likes api response : $response');
    }catch(e){
      print(" likes api error : $e");
    }finally{
      loading.value=false;
    }
  }
  Future<void> like(int postId) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');

      if (token == null || token.isEmpty) {
        print('token not found');
        return;
      }

      // Find the post index in feedList
      final index = feedList.indexWhere(
            (post) => post.id == postId,
      );

      if (index == -1) {
        print('Post not found: $postId');
        return;
      }

      if (feedList[index].isLiked) return;

      final response = await apiservice.like(
        token: token,
        postId: postId,
      );

      if (response.status == true && response.data != null) {
        feedList[index].isLiked =
            response.data!.isLiked ?? true;

        feedList[index].likesCount =
            response.data!.likesCount ??
                feedList[index].likesCount;

        feedList.refresh();

        print('Post liked successfully');
      }
    } catch (e) {
      print('Like API error: $e');
    }
  }

  Future<void> unLike(int postId) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');

      if (token == null || token.isEmpty) {
        print('token not found');
        return;
      }

      // Find the post index in feedList
      final index = feedList.indexWhere(
            (post) => post.id == postId,
      );

      if (index == -1) {
        print('Post not found: $postId');
        return;
      }

      if (!feedList[index].isLiked) return;
      final response = await apiservice.unLike(
        token: token,
        postId: postId,
      );

      if (response.status == true && response.data != null) {
        feedList[index].isLiked =
            response.data!.isLiked ?? true;

        feedList[index].likesCount =
            response.data!.likesCount ??
                feedList[index].likesCount;

        feedList.refresh();

        print('Post unliked successfully');
      }
    } catch (e) {
      print('unLike API error: $e');
    }
  }

  Future<void> addComment({
    required int postId,
    required String comment,
  }) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');

      if (token == null || token.isEmpty) {
        print('token not found');
        return;
      }

      if (comment.trim().isEmpty) {
        print('Comment cannot be empty');
        return;
      }

      final response = await apiservice.addComment(
        token: token,
        postId: postId,
        comment: comment.trim(),
      );

      if (response.status == true && response.data?.comment != null) {
        commentList.add(response.data!.comment!);

        final index = feedList.indexWhere(
              (post) => post.id == postId,
        );

        if (index != -1) {
          feedList[index].commentsCount =
              response.data!.commentsCount;

          feedList.refresh();
        }

        print('Comment added successfully');
      }
    } catch (e) {
      print('Add comment API error: $e');
    }
  }


  final ImagePicker picker = ImagePicker();
  final Rxn<XFile> selectedMedia = Rxn<XFile>();
  String? uploadedPostMediaPath;


  Future<void> pickFromGallery() async {
    final XFile? file = await picker.pickMedia();

    if (file == null) return;

    selectedMedia.value = file;

    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');

      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'Please login again');
        return;
      }

      loading.value = true;
      print('Selected media path: ${file.path}');
      print('Selected media type: ${file.mimeType}');
      print('Selected media size: ${await File(file.path).length()} bytes');
      final response = await apiservice.uploadPostMedia(
        token,
        File(file.path),
      );

      if (response.success && response.data != null) {
        uploadedPostMediaPath = response.data!.path;
        print('Uploaded post media path: $uploadedPostMediaPath');
      } else {
        Get.snackbar('Error', 'Media upload failed');
      }
    } catch (e) {
      print('Post media upload error: $e');
      Get.snackbar('Error', 'Unable to upload image or video');
    } finally {
      loading.value = false;
    }
  }

  Future<void> post({
    required String caption,
    required List<String> media
})async{

         try{

           loading.value=true;
          final  pref=await SharedPreferences.getInstance();
          final token=pref.getString('token');

          if(token==null||token.isEmpty){
            print("token not found");
            return;
          }

          final response=await apiservice.post(token: token, caption: caption, media: media);
          if (response.status && response.data != null) {
            feedList.insert(0, response.data!);
            feedList.refresh();
            selectedMedia.value = null;

            Get.back();

            print('Post created successfully');
    }}
          catch(e){
      print(e);
    }finally{
           loading.value=false;
         }
  }
    @override
    void onClose() {
    cameraController?.dispose();
    super.onClose();
    }
}