




class SendOtpModel {
  final bool status;
  final String message;
  final SendOtpData? data;

  SendOtpModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory SendOtpModel.fromJson(Map<String, dynamic> json) {
    return SendOtpModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? SendOtpData.fromJson(json['data'])
          : null,
    );
  }
}

class SendOtpData {
  final String countryCode;
  final String mobile;
  final String mobileDisplay;
  final int otpLength;
  final int expiresInSeconds;
  final int resendAfterSeconds;
  final String? otp;

  SendOtpData({
    required this.countryCode,
    required this.mobile,
    required this.mobileDisplay,
    required this.otpLength,
    required this.expiresInSeconds,
    required this.resendAfterSeconds,
    this.otp,
  });

  factory SendOtpData.fromJson(Map<String, dynamic> json) {
    return SendOtpData(
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
