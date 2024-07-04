// To parse this JSON data, do
//
//     final userEmailModel = userEmailModelFromJson(jsonString);

import 'dart:convert';

UserEmailModel userEmailModelFromJson(String str) =>
    UserEmailModel.fromJson(json.decode(str));

String userEmailModelToJson(UserEmailModel data) => json.encode(data.toJson());

class UserEmailModel {
  String email;

  UserEmailModel({
    required this.email,
  });

  factory UserEmailModel.fromJson(Map<String, dynamic> json) => UserEmailModel(
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
      };
}
