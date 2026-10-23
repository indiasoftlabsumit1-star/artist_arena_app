



class ProfileModel {
  final bool status;
  final String message;
  final ProfileData? data;

  ProfileModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? ProfileData.fromJson(json['data'])
          : null,
    );
  }


}

class ProfileData {
  final int id;
  final String firstName;
  final String lastName;
  final String name;
  final String email;
  final String countryCode;
  final String mobile;
  final String dateOfBirth;
  final String dateOfBirthDisplay;
  final String state;
  final String city;
  final int? categoryId;
  final CategoryModel? category;
  final String? avatar;
  final String? avatarUrl;
  final String? bio;
  final bool isActive;
  final bool isMobileVerified;
  final String joinedAt;

  ProfileData({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.name,
    required this.email,
    required this.countryCode,
    required this.mobile,
    required this.dateOfBirth,
    required this.dateOfBirthDisplay,
    required this.state,
    required this.city,
    this.categoryId,
    this.category,
    this.avatar,
    this.avatarUrl,
    this.bio,
    required this.isActive,
    required this.isMobileVerified,
    required this.joinedAt,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      countryCode: json['country_code'] ?? '',
      mobile: json['mobile'] ?? '',
      dateOfBirth: json['date_of_birth'] ?? '',
      dateOfBirthDisplay: json['date_of_birth_display'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      categoryId: json['category_id'],
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
      avatar: json['avatar'],
      avatarUrl: json['avatar_url'],
      bio: json['bio'],
      isActive: json['is_active'] ?? false,
      isMobileVerified: json['is_mobile_verified'] ?? false,
      joinedAt: json['joined_at'] ?? '',
    );
  }


}

class CategoryModel {
  final int id;
  final String name;

  CategoryModel({
    required this.id,
    required this.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }


}