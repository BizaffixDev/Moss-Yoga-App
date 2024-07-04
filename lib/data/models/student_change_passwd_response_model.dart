import 'dart:convert';

ChangePasswdResponseModel studentChangePasswdResponseModelFromJson(String str) => ChangePasswdResponseModel.fromJson(json.decode(str));

String studentChangePasswdResponseModelToJson(ChangePasswdResponseModel data) => json.encode(data.toJson());

class ChangePasswdResponseModel {
  String message;

  ChangePasswdResponseModel({
    required this.message,
  });

  factory ChangePasswdResponseModel.fromJson(Map<String, dynamic> json) => ChangePasswdResponseModel(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
