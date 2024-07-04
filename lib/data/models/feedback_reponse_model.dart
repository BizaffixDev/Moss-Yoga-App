// To parse this JSON data, do
//
//     final deleteAccountReponse = deleteAccountReponseFromJson(jsonString);

import 'dart:convert';

FeedbackResponse feedbacktReponseFromJson(String str) => FeedbackResponse.fromJson(json.decode(str));

String feedbackReponseToJson(FeedbackResponse data) => json.encode(data.toJson());

class FeedbackResponse {
  String message;

  FeedbackResponse({
    required this.message,
  });

  factory FeedbackResponse.fromJson(Map<String, dynamic> json) => FeedbackResponse(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
