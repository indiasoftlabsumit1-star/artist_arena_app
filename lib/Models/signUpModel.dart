


class SignupModel {
  final bool status;
  final String message;
  final SignupData? data;

  SignupModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory SignupModel.fromJson(Map<String, dynamic> json) {
    return SignupModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? SignupData.fromJson(json['data'])
          : null,
    );
  }
}

class SignupData {
  final String countryCode;
  final String mobile;
  final String mobileDisplay;
  final int otpLength;
  final int expiresInSeconds;
  final int resendAfterSeconds;
  final String? otp;

  SignupData({
    required this.countryCode,
    required this.mobile,
    required this.mobileDisplay,
    required this.otpLength,
    required this.expiresInSeconds,
    required this.resendAfterSeconds,
    this.otp,
  });

  factory SignupData.fromJson(Map<String, dynamic> json) {
    return SignupData(
      countryCode: json['country_code'] ?? '',
      mobile: json['mobile'] ?? '',
      mobileDisplay: json['mobile_display'] ?? '',
      otpLength: json['otp_length'] ?? 0,
      expiresInSeconds: json['expires_in_seconds'] ?? 0,
      resendAfterSeconds: json['resend_after_seconds'] ?? 0,
      otp: json['otp']?.toString(),
    );
  }
}