


class LikeModel {
  bool? status;
  String? message;
  LikeData? data;

  LikeModel({this.status, this.message, this.data});

  LikeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? LikeData.fromJson(json['data'])
        : null;
  }


}

class LikeData {
  int? postId;
  bool? isLiked;
  int? likesCount;

  LikeData({this.postId, this.isLiked, this.likesCount});

  LikeData.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    isLiked = json['is_liked'];
    likesCount = json['likes_count'];
  }



}