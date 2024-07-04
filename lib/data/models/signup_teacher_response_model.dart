// To parse this JSON data, do
//
//     final signUpTeacherResponse = signUpTeacherResponseFromJson(jsonString);

import 'dart:convert';

SignUpTeacherResponse signUpTeacherResponseFromJson(String str) =>
    SignUpTeacherResponse.fromJson(json.decode(str));

String signUpTeacherResponseToJson(SignUpTeacherResponse data) =>
    json.encode(data.toJson());

class SignUpTeacherResponse {
  int userId;
  String email;
  String username;
  String token;
  String userType;
  String message;
  bool isVerified;

  SignUpTeacherResponse({
    required this.userId,
    required this.email,
    required this.username,
    required this.token,
    required this.userType,
    required this.message,
    required this.isVerified,
  });

  factory SignUpTeacherResponse.fromJson(Map<String, dynamic> json) =>
      SignUpTeacherResponse(
        userId: json["userId"],
        email: json["email"],
        username: json["username"],
        token: json["token"],
        userType: json["userType"],
        message: json["message"],
        isVerified: json["isVerified"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "email": email,
        "username": username,
        "token": token,
        "userType": userType,
        "message": message,
        "isVerified": isVerified,
      };
}
