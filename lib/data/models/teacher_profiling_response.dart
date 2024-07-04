// To parse this JSON data, do
//
//     final teacherProfilingDetailResponse = teacherProfilingDetailResponseFromJson(jsonString);

import 'dart:convert';

TeacherProfilingDetailResponse teacherProfilingDetailResponseFromJson(
        String str) =>
    TeacherProfilingDetailResponse.fromJson(json.decode(str));

String teacherProfilingDetailResponseToJson(
        TeacherProfilingDetailResponse data) =>
    json.encode(data.toJson());

class TeacherProfilingDetailResponse {
  int userId;
  String email;
  String username;
  String token;
  String userType;
  String message;
  bool isVerified;

  TeacherProfilingDetailResponse({
    required this.userId,
    required this.email,
    required this.username,
    required this.token,
    required this.userType,
    required this.message,
    required this.isVerified,
  });

  factory TeacherProfilingDetailResponse.fromJson(Map<String, dynamic> json) =>
      TeacherProfilingDetailResponse(
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
