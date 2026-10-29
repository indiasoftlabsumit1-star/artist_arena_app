



class StorySeenModel {
  final int storyId;
  final bool isSeen;

  StorySeenModel({
    required this.storyId,
    required this.isSeen,
  });

  factory StorySeenModel.fromJson(Map<String, dynamic> json) {
    return StorySeenModel(
      storyId: json['story_id'] ?? 0,
      isSeen: json['is_seen'] ?? false,
    );
  }
}