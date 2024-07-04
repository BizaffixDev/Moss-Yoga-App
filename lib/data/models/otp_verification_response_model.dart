class OtpVerificationResponseModel {
  final String message;

  OtpVerificationResponseModel({required this.message});

  factory OtpVerificationResponseModel.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return OtpVerificationResponseModel(
        message: json['message'] as String,
      );
    } else if (json is String) {
      return OtpVerificationResponseModel(
        message: json,
      );
    } else {
      throw const FormatException('Invalid JSON format');
    }
  }
}
