import 'dart:convert';

GoogleLoginRequestBody googleLoginRequestBodyFromJson(String str) =>
    GoogleLoginRequestBody.fromJson(json.decode(str));

String googleLoginRequestBodyToJson(GoogleLoginRequestBody data) =>
    json.encode(data.toJson());

class GoogleLoginRequestBody {
  String id;
  String userName;
  String email;
  String profileImageUrl;
  String serverAuthCode;

  GoogleLoginRequestBody({
    required this.id,
    required this.userName,
    required this.email,
    required this.profileImageUrl,
    required this.serverAuthCode,
  });

  factory GoogleLoginRequestBody.fromJson(Map<String, dynamic> json) =>
      GoogleLoginRequestBody(
        id: json["id"],
        userName: json["userName"],
        email: json["email"],
        profileImageUrl: json["profileImageUrl"],
        serverAuthCode: json["serverAuthCode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userName": userName,
        "email": email,
        "profileImageUrl": profileImageUrl,
        "serverAuthCode": serverAuthCode,
      };
}
