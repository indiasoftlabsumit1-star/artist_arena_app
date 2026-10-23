





class CommentListModel {
  final bool status;
  final String message;
  final CommentListData data;

  CommentListModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CommentListModel.fromJson(Map<String, dynamic> json) {
    return CommentListModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: CommentListData.fromJson(json['data'] ?? {}),
    );
  }
}

class CommentListData {
  final int postId;
  final int commentsCount;
  final List<CommentItem> items;
  final CommentPagination pagination;

  CommentListData({
    required this.postId,
    required this.commentsCount,
    required this.items,
    required this.pagination,
  });

  factory CommentListData.fromJson(Map<String, dynamic> json) {
    return CommentListData(
      postId: json['post_id'] ?? 0,
      commentsCount: json['comments_count'] ?? 0,
      items: (json['items'] as List? ?? [])
          .map((item) => CommentItem.fromJson(item))
          .toList(),
      pagination: CommentPagination.fromJson(
        json['pagination'] ?? {},
      ),
    );
  }
}

class CommentItem {
  final int id;
  final int postId;
  final String comment;
  final CommentUser user;
  final bool isMine;
  final bool canDelete;
  final String createdAt;
  final String timeAgo;

  CommentItem({
    required this.id,
    required this.postId,
    required this.comment,
    required this.user,
    required this.isMine,
    required this.canDelete,
    required this.createdAt,
    required this.timeAgo,
  });

  factory CommentItem.fromJson(Map<String, dynamic> json) {
    return CommentItem(
      id: json['id'] ?? 0,
      postId: json['post_id'] ?? 0,
      comment: json['comment'] ?? '',
      user: CommentUser.fromJson(json['user'] ?? {}),
      isMine: json['is_mine'] ?? false,
      canDelete: json['can_delete'] ?? false,
      createdAt: json['created_at'] ?? '',
      timeAgo: json['time_ago'] ?? '',
    );
  }
}

class CommentUser {
  final int id;
  final String name;
  final String? avatar;
  final String? avatarUrl;
  final String? category;
  final String? city;
  final String? bio;
  final bool isMe;
  final bool isFollowing;

  CommentUser({
    required this.id,
    required this.name,
    this.avatar,
    this.avatarUrl,
    this.category,
    this.city,
    this.bio,
    required this.isMe,
    required this.isFollowing,
  });

  factory CommentUser.fromJson(Map<String, dynamic> json) {
    return CommentUser(
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

class CommentPagination {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final bool hasMore;

  CommentPagination({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.hasMore,
  });

  factory CommentPagination.fromJson(Map<String, dynamic> json) {
    return CommentPagination(
      currentPage: json['current_page'] ?? 1,
      perPage: json['per_page'] ?? 20,
      total: json['total'] ?? 0,
      lastPage: json['last_page'] ?? 1,
      hasMore: json['has_more'] ?? false,
    );
  }
}
