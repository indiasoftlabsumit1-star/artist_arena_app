




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
import '../Widgets/errorHandel.dart';

class FeedController extends GetxController{

  CameraController? cameraController;

  final Apiservice apiservice = Apiservice();
  final Errorhandel errorhandel = Errorhandel();

  final RxList<FeedItem> feedList = <FeedItem>[].obs;

  final RxList<CommentItem> commentList=<CommentItem>[].obs;
final RxList<LikeItem>  likeItem=<LikeItem>[].obs;
  final RxBool feedLoading = false.obs;
  final RxBool commentLoading = false.obs;
  final RxBool likesLoading = false.obs;
  final RxBool mediaLoading = false.obs;
  final RxBool postLoading = false.obs;  final profileController=Get.find<ProfileController>();



  Future<void> getFeed() async {
    try {
      feedLoading.value = true;

      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');

      if (token == null || token.isEmpty) {
        Get.snackbar(
          'Login Required',
          'Please login again to view your feed.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final response = await apiservice.getFeed(
        token: token,
      );

      feedList.value = response.data.items;
    } catch (e) {
      print('GET FEED ERROR TYPE: ${e.runtimeType}');
      print('GET FEED ERROR: $e');

      errorhandel.showApiError('load feed', e);
    } finally {
      feedLoading.value = false;
    }
  }Future<void> getComment(int postId) async {
    try {
      commentLoading.value = true;

      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');

      if (token == null || token.isEmpty) {
        Get.snackbar(
          'Login Required',
          'Please login again to view comments.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final response = await apiservice.getComment(
        token: token,
        postId: postId,
      );

      commentList.value = response.data.items;
    } catch (e) {
      errorhandel.showApiError('load comments', e);
    } finally {
      commentLoading.value = false;
    }
  }

  Future<void> getLikes(int postId) async {
    try {
      likesLoading.value = true;

      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');

      if (token == null || token.isEmpty) {
        Get.snackbar(
          'Login Required',
          'Please login again to view likes.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final response = await apiservice.getLikes(
        token: token,
        postId: postId,
      );

      likeItem.value = response.data.items;
    } catch (e) {
      errorhandel.showApiError('load likes', e);
    } finally {
      likesLoading.value = false;
    }
  }Future<void> like(int postId) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');

      if (token == null || token.isEmpty) {
        Get.snackbar(
          'Login Required',
          'Please login again to like this post.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final index = feedList.indexWhere(
            (post) => post.id == postId,
      );

      if (index == -1) {
        Get.snackbar(
          'Error',
          'Post not found. Please refresh your feed.',
          snackPosition: SnackPosition.BOTTOM,
        );
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
      } else {
        Get.snackbar(
          'Error',
          'Unable to like this post. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      errorhandel.showApiError('like post', e);
    }
  }
  Future<void> unLike(int postId) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');

      if (token == null || token.isEmpty) {
        Get.snackbar(
          'Login Required',
          'Please login again to unlike this post.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final index = feedList.indexWhere(
            (post) => post.id == postId,
      );

      if (index == -1) {
        Get.snackbar(
          'Error',
          'Post not found. Please refresh your feed.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      if (!feedList[index].isLiked) return;

      final response = await apiservice.unLike(
        token: token,
        postId: postId,
      );

      if (response.status == true && response.data != null) {
        feedList[index].isLiked =
            response.data!.isLiked ?? false;

        feedList[index].likesCount =
            response.data!.likesCount ??
                feedList[index].likesCount;

        feedList.refresh();
      } else {
        Get.snackbar(
          'Error',
          'Unable to unlike this post. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      errorhandel.showApiError('unlike post', e);
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
        Get.snackbar(
          'Login Required',
          'Please login again to add a comment.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      if (comment.trim().isEmpty) {
        Get.snackbar(
          'Empty Comment',
          'Please enter a comment first.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final response = await apiservice.addComment(
        token: token,
        postId: postId,
        comment: comment.trim(),
      );

      if (response.status == true &&
          response.data?.comment != null) {
        commentList.add(response.data!.comment!);

        final index = feedList.indexWhere(
              (post) => post.id == postId,
        );

        if (index != -1) {
          feedList[index].commentsCount =
              response.data!.commentsCount;
          feedList.refresh();
        }
      } else {
        Get.snackbar(
          'Error',
          'Unable to add comment. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      errorhandel.showApiError('add comment', e);
    }
  }


  final ImagePicker picker = ImagePicker();
  final Rxn<XFile> selectedMedia = Rxn<XFile>();
  String? uploadedPostMediaPath;

  Future<void> pickFromGallery() async {
    try {
      final XFile? file = await picker.pickMedia();

      if (file == null) return;

      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');

      if (token == null || token.isEmpty) {
        Get.snackbar(
          'Login Required',
          'Please login again to upload media.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      mediaLoading.value = true;

      selectedMedia.value = file;
      uploadedPostMediaPath = null;

      final response = await apiservice.uploadPostMedia(
        token,
        File(file.path),
      );

      if (response.success && response.data != null) {
        uploadedPostMediaPath = response.data!.path;
      } else {
        uploadedPostMediaPath = null;

        Get.snackbar(
          'Upload Failed',
          'Unable to upload media. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      uploadedPostMediaPath = null;
      errorhandel.showApiError('upload media', e);
    } finally {
      mediaLoading.value = false;
    }
  }
  Future<void> post({
    required String caption,
    required List<String> media,
  }) async {
    try {
      postLoading.value = true;

      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');

      if (token == null || token.isEmpty) {
        Get.snackbar(
          'Login Required',
          'Please login again to create a post.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final response = await apiservice.post(
        token: token,
        caption: caption,
        media: media,
      );

      if (response.status && response.data != null) {
        feedList.insert(0, response.data!);
        selectedMedia.value = null;

        Get.back();
      } else {
        Get.snackbar(
          'Error',
          'Unable to create post. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      errorhandel.showApiError('create post', e);
    } finally {
      postLoading.value = false;
    }
  }
    @override
    void onClose() {
    cameraController?.dispose();
    super.onClose();
    }
}