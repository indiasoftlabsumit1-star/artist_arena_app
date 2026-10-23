





class LikeListModel {
  final bool status;
  final String message;
  final LikeListData data;

  LikeListModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LikeListModel.fromJson(Map<String, dynamic> json) {
    return LikeListModel(
      status: json['status'],
      message: json['message'],
      data: LikeListData.fromJson(json['data']),
    );
  }
}

class LikeListData {
  final int postId;
  final int likesCount;
  final List<LikeItem> items;
  final LikePagination pagination;

  LikeListData({
    required this.postId,
    required this.likesCount,
    required this.items,
    required this.pagination,
  });

  factory LikeListData.fromJson(Map<String, dynamic> json) {
    return LikeListData(
      postId: json['post_id'],
      likesCount: json['likes_count'],
      items: (json['items'] as List)
          .map((item) => LikeItem.fromJson(item))
          .toList(),
      pagination: LikePagination.fromJson(json['pagination']),
    );
  }
}

class LikeItem {
  final int id;
  final String name;
  final String? avatar;
  final String? avatarUrl;
  final String category;
  final String city;
  final String bio;
  final bool isMe;
  final bool isFollowing;

  LikeItem({
    required this.id,
    required this.name,
    this.avatar,
    this.avatarUrl,
    required this.category,
    required this.city,
    required this.bio,
    required this.isMe,
    required this.isFollowing,
  });

  factory LikeItem.fromJson(Map<String, dynamic> json) {
    return LikeItem(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      avatarUrl: json['avatar_url'],
      category: json['category'],
      city: json['city'],
      bio: json['bio'],
      isMe: json['is_me'],
      isFollowing: json['is_following'],
    );
  }
}

class LikePagination {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final bool hasMore;

  LikePagination({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.hasMore,
  });

  factory LikePagination.fromJson(Map<String, dynamic> json) {
    return LikePagination(
      currentPage: json['current_page'],
      perPage: json['per_page'],
      total: json['total'],
      lastPage: json['last_page'],
      hasMore: json['has_more'],
    );
  }
}
