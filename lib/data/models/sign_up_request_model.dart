import 'dart:convert';

SignupRequest signupRequestFromJson(String str) => SignupRequest.fromJson(json.decode(str));

String signupRequestToJson(SignupRequest data) => json.encode(data.toJson());

class SignupRequest {
  String username;
  String email;
  String password;
  String confirmPassword;

  SignupRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  factory SignupRequest.fromJson(Map<String, dynamic> json) => SignupRequest(
    username: json["username"],
    email: json["email"],
    password: json["password"],
    confirmPassword: json["confirmPassword"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "email": email,
    "password": password,
    "confirmPassword": confirmPassword,
  };
}
