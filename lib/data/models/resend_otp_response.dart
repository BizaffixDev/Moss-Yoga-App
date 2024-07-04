// To parse this JSON data, do
//
//     final resendOtpResponse = resendOtpResponseFromJson(jsonString);

import 'dart:convert';

ResendOtpResponse resendOtpResponseFromJson(String str) => ResendOtpResponse.fromJson(json.decode(str));

String resendOtpResponseToJson(ResendOtpResponse data) => json.encode(data.toJson());

class ResendOtpResponse {
  String message;

  ResendOtpResponse({
    required this.message,
  });

  factory ResendOtpResponse.fromJson(Map<String, dynamic> json) => ResendOtpResponse(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
