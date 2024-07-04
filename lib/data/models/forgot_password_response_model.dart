import 'dart:convert';

class ForgotPasswordResponseModel {
  String message;

  ForgotPasswordResponseModel({
    required this.message,
  });

  factory ForgotPasswordResponseModel.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return ForgotPasswordResponseModel(
        message: json['message'] as String,
      );
    } else if (json is String) {
      return ForgotPasswordResponseModel(
        message: json,
      );
    } else {
      throw const FormatException('Invalid JSON format');
    }
  }

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}

ForgotPasswordResponseModel forgotPasswordResponseModelFromJson(String str) =>
    ForgotPasswordResponseModel.fromJson(json.decode(str));

String forgotPasswordResponseModelToJson(ForgotPasswordResponseModel data) =>
    json.encode(data.toJson());
