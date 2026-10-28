import 'storyModel.dart';

class MyStoryModel {
  final bool status;
  final String message;
  final List<StoryItem> data;

  MyStoryModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MyStoryModel.fromJson(Map<String, dynamic> json) {
    return MyStoryModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map(
            (item) => StoryItem.fromJson(
          item as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }
}