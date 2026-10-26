import 'commentModel.dart';

class AddCommentModel {
  final bool status;
  final String message;
  final AddCommentData? data;

  AddCommentModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory AddCommentModel.fromJson(Map<String, dynamic> json) {
    return AddCommentModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? AddCommentData.fromJson(json['data'])
          : null,
    );
  }
}

class AddCommentData {
  final CommentItem? comment;
  final int commentsCount;

  AddCommentData({
    this.comment,
    required this.commentsCount,
  });

  factory AddCommentData.fromJson(Map<String, dynamic> json) {
    return AddCommentData(
      comment: json['comment'] != null
          ? CommentItem.fromJson(json['comment'])
          : null,
      commentsCount: json['comments_count'] ?? 0,
    );
  }
}