class ResetPasswordResponseModel {
  final String message;

  ResetPasswordResponseModel({required this.message});

  factory ResetPasswordResponseModel.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return ResetPasswordResponseModel(
        message: json['message'] as String,
      );
    } else if (json is String) {
      return ResetPasswordResponseModel(
        message: json,
      );
    } else {
      throw const FormatException('Invalid JSON format');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
