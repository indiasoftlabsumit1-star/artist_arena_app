

class FeedModel {
  final bool status;
  final String message;
  final FeedData data;

  FeedModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory FeedModel.fromJson(Map<String, dynamic> json) {
    return FeedModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: FeedData.fromJson(json['data'] ?? {}),
    );
  }
}

class FeedData {
  final String sort;
  final List<FeedItem> items;
  final FeedPagination pagination;

  FeedData({
    required this.sort,
    required this.items,
    required this.pagination,
  });

  factory FeedData.fromJson(Map<String, dynamic> json) {
    return FeedData(
      sort: json['sort'] ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => FeedItem.fromJson(
        item as Map<String, dynamic>,
      ))
          .toList(),
      pagination: FeedPagination.fromJson(
        json['pagination'] ?? {},
      ),
    );
  }
}

class FeedItem {
  final int id;
  final String caption;
  final List<FeedMedia> media;
  final int mediaCount;
  final String? thumbnailUrl;
  final FeedUser user;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final bool isMine;
  final bool canDelete;
  final bool isActive;
  final FeedComment? latestComment;
  final String createdAt;
  final String timeAgo;

  FeedItem({
    required this.id,
    required this.caption,
    required this.media,
    required this.mediaCount,
    required this.thumbnailUrl,
    required this.user,
    required this.likesCount,
    required this.commentsCount,
    required this.isLiked,
    required this.isMine,
    required this.canDelete,
    required this.isActive,
    required this.latestComment,
    required this.createdAt,
    required this.timeAgo,
  });

  factory FeedItem.fromJson(Map<String, dynamic> json) {
    return FeedItem(
      id: json['id'] ?? 0,
      caption: json['caption'] ?? '',
      media: (json['media'] as List<dynamic>? ?? [])
          .map((item) => FeedMedia.fromJson(
        item as Map<String, dynamic>,
      ))
          .toList(),
      mediaCount: json['media_count'] ?? 0,
      thumbnailUrl: json['thumbnail_url'],
      user: FeedUser.fromJson(json['user'] ?? {}),
      likesCount: json['likes_count'] ?? 0,
      commentsCount: json['comments_count'] ?? 0,
      isLiked: json['is_liked'] ?? false,
      isMine: json['is_mine'] ?? false,
      canDelete: json['can_delete'] ?? false,
      isActive: json['is_active'] ?? false,
      latestComment: json['latest_comment'] == null
          ? null
          : FeedComment.fromJson(json['latest_comment']),
      createdAt: json['created_at'] ?? '',
      timeAgo: json['time_ago'] ?? '',
    );
  }
}

class FeedMedia {
  final String path;
  final String url;
  final String type;

  FeedMedia({
    required this.path,
    required this.url,
    required this.type,
  });

  factory FeedMedia.fromJson(Map<String, dynamic> json) {
    return FeedMedia(
      path: json['path'] ?? '',
      url: json['url'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

class FeedUser {
  final int id;
  final String name;
  final String? avatar;
  final String? avatarUrl;
  final String? category;
  final String? city;
  final String? bio;
  final bool isMe;
  final bool isFollowing;

  FeedUser({
    required this.id,
    required this.name,
    required this.avatar,
    required this.avatarUrl,
    required this.category,
    required this.city,
    required this.bio,
    required this.isMe,
    required this.isFollowing,
  });

  factory FeedUser.fromJson(Map<String, dynamic> json) {
    return FeedUser(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      avatar: json['avatar'],
      avatarUrl: json['avatar_url'],
      category: json['category'],
      city: json['city'],
      bio: json['bio'],
      isMe: json['is_me'] ?? false,
      isFollowing: json['is_following'] ?? false,
    );
  }
}

class FeedComment {
  final int id;
  final int postId;
  final String comment;
  final FeedUser user;
  final bool isMine;
  final bool canDelete;
  final String createdAt;
  final String timeAgo;

  FeedComment({
    required this.id,
    required this.postId,
    required this.comment,
    required this.user,
    required this.isMine,
    required this.canDelete,
    required this.createdAt,
    required this.timeAgo,
  });

  factory FeedComment.fromJson(Map<String, dynamic> json) {
    return FeedComment(
      id: json['id'] ?? 0,
      postId: json['post_id'] ?? 0,
      comment: json['comment'] ?? '',
      user: FeedUser.fromJson(json['user'] ?? {}),
      isMine: json['is_mine'] ?? false,
      canDelete: json['can_delete'] ?? false,
      createdAt: json['created_at'] ?? '',
      timeAgo: json['time_ago'] ?? '',
    );
  }
}

class FeedPagination {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final bool hasMore;

  FeedPagination({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.hasMore,
  });

  factory FeedPagination.fromJson(Map<String, dynamic> json) {
    return FeedPagination(
      currentPage: json['current_page'] ?? 1,
      perPage: json['per_page'] ?? 10,
      total: json['total'] ?? 0,
      lastPage: json['last_page'] ?? 1,
      hasMore: json['has_more'] ?? false,
    );
  }
}