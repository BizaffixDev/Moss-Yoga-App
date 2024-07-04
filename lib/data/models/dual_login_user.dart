// To parse this JSON data, do
//
//     final dualLoginUser = dualLoginUserFromJson(jsonString);

import 'dart:convert';

DualLoginUser dualLoginUserFromJson(String str) =>
    DualLoginUser.fromJson(json.decode(str));

String dualLoginUserToJson(DualLoginUser data) => json.encode(data.toJson());

class DualLoginUser {
  int id;
  String email;
  String token;
  String userType;

  DualLoginUser({
    required this.id,
    required this.email,
    required this.token,
    required this.userType,
  });

  factory DualLoginUser.fromJson(Map<String, dynamic> json) => DualLoginUser(
        id: json["id"],
        email: json["email"],
        token: json["token"],
        userType: json["userType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "token": token,
        "userType": userType,
      };
}
