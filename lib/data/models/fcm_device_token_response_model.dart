// To parse this JSON data, do
//
//     final fcmDeviceTokenResponseModel = fcmDeviceTokenResponseModelFromJson(jsonString);

import 'dart:convert';

FcmDeviceTokenResponseModel fcmDeviceTokenResponseModelFromJson(String str) =>
    FcmDeviceTokenResponseModel.fromJson(json.decode(str));

String fcmDeviceTokenResponseModelToJson(FcmDeviceTokenResponseModel data) =>
    json.encode(data.toJson());

class FcmDeviceTokenResponseModel {
  String message;

  FcmDeviceTokenResponseModel({
    required this.message,
  });

  factory FcmDeviceTokenResponseModel.fromJson(Map<String, dynamic> json) =>
      FcmDeviceTokenResponseModel(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}
