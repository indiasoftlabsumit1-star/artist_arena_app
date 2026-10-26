




class UploadFileModel {
  final bool success;
  final String message;
  final UploadFileData? data;

  UploadFileModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory UploadFileModel.fromJson(Map<String, dynamic> json) {
    return UploadFileModel(
      success: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? UploadFileData.fromJson(json['data'])
          : null,
    );
  }
}

class UploadFileData {
  final String path;
  final String url;
  final String originalName;
  final String mimeType;
  final int size;

  UploadFileData({
    required this.path,
    required this.url,
    required this.originalName,
    required this.mimeType,
    required this.size,
  });

  factory UploadFileData.fromJson(Map<String, dynamic> json) {
    return UploadFileData(
      path: json['path'] ?? '',
      url: json['url'] ?? '',
      originalName: json['original_name'] ?? '',
      mimeType: json['mime_type'] ?? '',
      size: json['size'] ?? 0,
    );
  }
}