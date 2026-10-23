


class VerifyOtpModel {
  final bool status;
  final String message;
  final VerifyOtpData? data;

  VerifyOtpModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory VerifyOtpModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? VerifyOtpData.fromJson(json['data'])
          : null,
    );
  }
}

class VerifyOtpData {
  final String token;
  final String tokenType;
  final bool isNewUser;
  final VerifyOtpUser? user;

  VerifyOtpData({
    required this.token,
    required this.tokenType,
    required this.isNewUser,
    this.user,
  });

  factory VerifyOtpData.fromJson(Map<String, dynamic> json) {
    return VerifyOtpData(
      token: json['token'] ?? '',
      tokenType: json['token_type'] ?? '',
      isNewUser: json['is_new_user'] ?? false,
      user: json['user'] != null
          ? VerifyOtpUser.fromJson(json['user'])
          : null,
    );
  }
}

class VerifyOtpUser {
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
  final int categoryId;
  final VerifyOtpCategory? category;
  final String? avatar;
  final String? avatarUrl;
  final String? bio;
  final bool isActive;
  final bool isMobileVerified;
  final String joinedAt;

  VerifyOtpUser({
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
    required this.categoryId,
    this.category,
    this.avatar,
    this.avatarUrl,
    this.bio,
    required this.isActive,
    required this.isMobileVerified,
    required this.joinedAt,
  });

  factory VerifyOtpUser.fromJson(Map<String, dynamic> json) {
    return VerifyOtpUser(
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
      categoryId: json['category_id'] ?? 0,
      category: json['category'] != null
          ? VerifyOtpCategory.fromJson(json['category'])
          : null,
      avatar: json['avatar']?.toString(),
      avatarUrl: json['avatar_url']?.toString(),
      bio: json['bio']?.toString(),
      isActive: json['is_active'] ?? false,
      isMobileVerified: json['is_mobile_verified'] ?? false,
      joinedAt: json['joined_at'] ?? '',
    );
  }
}

class VerifyOtpCategory {
  final int id;
  final String name;

  VerifyOtpCategory({
    required this.id,
    required this.name,
  });

  factory VerifyOtpCategory.fromJson(Map<String, dynamic> json) {
    return VerifyOtpCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}