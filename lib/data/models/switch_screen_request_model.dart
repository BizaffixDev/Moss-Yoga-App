// To parse this JSON data, do
//
//     final switchScreenRequestModel = switchScreenRequestModelFromJson(jsonString);

import 'dart:convert';

SwitchScreenRequestModel switchScreenRequestModelFromJson(String str) =>
    SwitchScreenRequestModel.fromJson(json.decode(str));

String switchScreenRequestModelToJson(SwitchScreenRequestModel data) =>
    json.encode(data.toJson());

class SwitchScreenRequestModel {
  int userId;
  String email;
  String username;
  String token;
  String userType;

  SwitchScreenRequestModel({
    required this.userId,
    required this.email,
    required this.username,
    required this.token,
    required this.userType,
  });

  factory SwitchScreenRequestModel.fromJson(Map<String, dynamic> json) =>
      SwitchScreenRequestModel(
        userId: json["userId"],
        email: json["email"],
        username: json["username"],
        token: json["token"],
        userType: json["userType"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "email": email,
        "username": username,
        "token": token,
        "userType": userType,
      };
}
