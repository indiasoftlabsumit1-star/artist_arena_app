



class CreateStoryModel {
  final bool status;
  final String message;
  final CreateStoryData? data;

  CreateStoryModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory CreateStoryModel.fromJson(Map<String, dynamic> json) {
    return CreateStoryModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? CreateStoryData.fromJson(json['data'])
          : null,
    );
  }
}

class CreateStoryData {
  final int id;
  final int userId;
  final String media;
  final String mediaUrl;
  final String type;
  final String caption;
  final bool isSeen;
  final bool isMine;
  final bool canDelete;
  final int viewsCount;
  final String createdAt;
  final String timeAgo;
  final String expiresAt;

  CreateStoryData({
    required this.id,
    required this.userId,
    required this.media,
    required this.mediaUrl,
    required this.type,
    required this.caption,
    required this.isSeen,
    required this.isMine,
    required this.canDelete,
    required this.viewsCount,
    required this.createdAt,
    required this.timeAgo,
    required this.expiresAt,
  });

  factory CreateStoryData.fromJson(Map<String, dynamic> json) {
    return CreateStoryData(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      media: json['media'] ?? '',
      mediaUrl: json['media_url'] ?? '',
      type: json['type'] ?? '',
      caption: json['caption'] ?? '',
      isSeen: json['is_seen'] ?? false,
      isMine: json['is_mine'] ?? false,
      canDelete: json['can_delete'] ?? false,
      viewsCount: json['views_count'] ?? 0,
      createdAt: json['created_at'] ?? '',
      timeAgo: json['time_ago'] ?? '',
      expiresAt: json['expires_at'] ?? '',
    );
  }
}
