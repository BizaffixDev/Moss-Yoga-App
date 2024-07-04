// To parse this JSON data, do
//
//     final switchScreenResponseModel = switchScreenResponseModelFromJson(jsonString);

import 'dart:convert';

SwitchScreenResponseModel switchScreenResponseModelFromJson(String str) =>
    SwitchScreenResponseModel.fromJson(json.decode(str));

String switchScreenResponseModelToJson(SwitchScreenResponseModel data) =>
    json.encode(data.toJson());

class SwitchScreenResponseModel {
  int userId;
  String email;
  String username;
  String token;
  String userType;
  String message;
  bool isVerified;

  SwitchScreenResponseModel({
    required this.userId,
    required this.email,
    required this.username,
    required this.token,
    required this.userType,
    required this.message,
    required this.isVerified,
  });

  factory SwitchScreenResponseModel.fromJson(Map<String, dynamic> json) =>
      SwitchScreenResponseModel(
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
