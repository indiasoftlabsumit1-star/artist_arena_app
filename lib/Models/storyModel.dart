


class StoriesRowModel {
  final bool status;
  final String message;
  final StoriesRowData? data;

  StoriesRowModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory StoriesRowModel.fromJson(Map<String, dynamic> json) {
    return StoriesRowModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? StoriesRowData.fromJson(json['data'])
          : null,
    );
  }
}

class StoriesRowData {
  final MyStoryData? myStory;
  final List<StoryRowItem> items;

  StoriesRowData({
    this.myStory,
    required this.items,
  });

  factory StoriesRowData.fromJson(Map<String, dynamic> json) {
    return StoriesRowData(
      myStory: json['my_story'] != null
          ? MyStoryData.fromJson(json['my_story'])
          : null,
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => StoryRowItem.fromJson(e))
          .toList(),
    );
  }
}

class MyStoryData {
  final StoryUser user;
  final bool hasStory;
  final int storiesCount;

  MyStoryData({
    required this.user,
    required this.hasStory,
    required this.storiesCount,
  });

  factory MyStoryData.fromJson(Map<String, dynamic> json) {
    return MyStoryData(
      user: StoryUser.fromJson(json['user'] ?? {}),
      hasStory: json['has_story'] ?? false,
      storiesCount: json['stories_count'] ?? 0,
    );
  }
}

class StoryRowItem {
  final StoryUser user;
   bool hasUnseen;
  final int storiesCount;
  final String latestAt;
  final List<StoryItem> stories;

  StoryRowItem({
    required this.user,
    required this.hasUnseen,
    required this.storiesCount,
    required this.latestAt,
    required this.stories,
  });

  factory StoryRowItem.fromJson(Map<String, dynamic> json) {
    return StoryRowItem(
      user: StoryUser.fromJson(json['user'] ?? {}),
      hasUnseen: json['has_unseen'] ?? false,
      storiesCount: json['stories_count'] ?? 0,
      latestAt: json['latest_at'] ?? '',
      stories: (json['stories'] as List<dynamic>? ?? [])
          .map((e) => StoryItem.fromJson(e))
          .toList(),
    );
  }
}

class StoryUser {
  final int id;
  final String name;
  final String? avatar;
  final String? avatarUrl;
  final String? category;
  final String? city;
  final String? bio;
  final bool isMe;
  final bool isFollowing;

  StoryUser({
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

  factory StoryUser.fromJson(Map<String, dynamic> json) {
    return StoryUser(
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

class StoryItem {
  final int id;
  final int userId;
  final String media;
  final String mediaUrl;
  final String type;
  final String caption;
   bool isSeen;
  final bool isMine;
  final bool canDelete;
  final int viewsCount;
  final String createdAt;
  final String timeAgo;
  final String expiresAt;

  StoryItem({
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

  factory StoryItem.fromJson(Map<String, dynamic> json) {
    return StoryItem(
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
