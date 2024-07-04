// To parse this JSON data, do
//
//     final deviceTokenRequestModel = deviceTokenRequestModelFromJson(jsonString);

import 'dart:convert';

DeviceTokenRequestModel deviceTokenRequestModelFromJson(String str) =>
    DeviceTokenRequestModel.fromJson(json.decode(str));

String deviceTokenRequestModelToJson(DeviceTokenRequestModel data) =>
    json.encode(data.toJson());

class DeviceTokenRequestModel {
  int userId;
  String deviceToken;

  DeviceTokenRequestModel({
    required this.userId,
    required this.deviceToken,
  });

  factory DeviceTokenRequestModel.fromJson(Map<String, dynamic> json) =>
      DeviceTokenRequestModel(
        userId: json["userId"],
        deviceToken: json["deviceToken"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "deviceToken": deviceToken,
      };
}
