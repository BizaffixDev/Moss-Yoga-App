// To parse this JSON data, do
//
//     final studentChangePasswdRequestModel = studentChangePasswdRequestModelFromJson(jsonString);

import 'dart:convert';

ChangePasswdRequestModel studentChangePasswdRequestModelFromJson(String str) => ChangePasswdRequestModel.fromJson(json.decode(str));

String studentChangePasswdRequestModelToJson(ChangePasswdRequestModel data) => json.encode(data.toJson());

class ChangePasswdRequestModel {
  String email;
  String oldPassword;
  String newPassword;
  String confirmPassword;

  ChangePasswdRequestModel({
    required this.email,
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  factory ChangePasswdRequestModel.fromJson(Map<String, dynamic> json) => ChangePasswdRequestModel(
    email: json["email"],
    oldPassword: json["oldPassword"],
    newPassword: json["newPassword"],
    confirmPassword: json["confirmPassword"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "oldPassword": oldPassword,
    "newPassword": newPassword,
    "confirmPassword": confirmPassword,
  };
}
