// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) =>
    json.encode(data.toJson());

class LoginResponseModel {
  int userId;
  String email;
  String username;
  String token;
  String userType;
  String message;
  bool isVerified;

  LoginResponseModel({
    required this.userId,
    required this.email,
    required this.username,
    required this.token,
    required this.userType,
    required this.message,
    required this.isVerified,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
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
