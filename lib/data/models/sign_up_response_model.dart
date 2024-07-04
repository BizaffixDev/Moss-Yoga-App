// To parse this JSON data, do
//
//     final signupResponseModel = signupResponseModelFromJson(jsonString);

import 'dart:convert';

SignupResponseModel signupResponseModelFromJson(String str) =>
    SignupResponseModel.fromJson(json.decode(str));

String signupResponseModelToJson(SignupResponseModel data) =>
    json.encode(data.toJson());

class SignupResponseModel {
  int userId;
  String email;
  String username;
  String token;
  String userType;
  String message;
  bool isVerified;

  SignupResponseModel({
    required this.userId,
    required this.email,
    required this.username,
    required this.token,
    required this.userType,
    required this.message,
    required this.isVerified,
  });

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) =>
      SignupResponseModel(
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
