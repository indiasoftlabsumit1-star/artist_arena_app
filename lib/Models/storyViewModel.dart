




class StoryViewModel {
  final bool status;
  final String message;
  final StoryViewData? data;

  StoryViewModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory StoryViewModel.fromJson(Map<String, dynamic> json) {
    return StoryViewModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? StoryViewData.fromJson(json['data'])
          : null,
    );
  }
}

class StoryViewData {
  final int storyId;
  final int viewsCount;
  final List<StoryViewer> items;

  StoryViewData({
    required this.storyId,
    required this.viewsCount,
    required this.items,
  });

  factory StoryViewData.fromJson(Map<String, dynamic> json) {
    return StoryViewData(
      storyId: json['story_id'] ?? 0,
      viewsCount: json['views_count'] ?? 0,
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => StoryViewer.fromJson(e))
          .toList(),
    );
  }
}

class StoryViewer {
  final int id;
  final String name;
  final String? avatar;
  final String? avatarUrl;
  final String? category;
  final String? city;
  final String? bio;
  final bool isMe;
  final bool isFollowing;

  StoryViewer({
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

  factory StoryViewer.fromJson(Map<String, dynamic> json) {
    return StoryViewer(
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
