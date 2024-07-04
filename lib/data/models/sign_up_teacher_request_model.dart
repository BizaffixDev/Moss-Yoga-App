// To parse this JSON data, do
//
//     final signUpTeacherRequest = signUpTeacherRequestFromJson(jsonString);

import 'dart:convert';

SignUpTeacherRequest signUpTeacherRequestFromJson(String str) => SignUpTeacherRequest.fromJson(json.decode(str));

String signUpTeacherRequestToJson(SignUpTeacherRequest data) => json.encode(data.toJson());

class SignUpTeacherRequest {
  String username;
  String email;
  String password;
  int roleId;

  SignUpTeacherRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.roleId,
  });

  factory SignUpTeacherRequest.fromJson(Map<String, dynamic> json) => SignUpTeacherRequest(
    username: json["username"],
    email: json["email"],
    password: json["password"],
    roleId: json["roleId"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "email": email,
    "password": password,
    "roleId": roleId,
  };
}
