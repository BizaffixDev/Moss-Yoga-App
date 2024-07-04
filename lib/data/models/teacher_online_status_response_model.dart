// To parse this JSON data, do
//
//     final teacherOnlineStatusResponseModel = teacherOnlineStatusResponseModelFromJson(jsonString);

import 'dart:convert';

TeacherOnlineStatusResponseModel teacherOnlineStatusResponseModelFromJson(
        String str) =>
    TeacherOnlineStatusResponseModel.fromJson(json.decode(str));

String teacherOnlineStatusResponseModelToJson(
        TeacherOnlineStatusResponseModel data) =>
    json.encode(data.toJson());

class TeacherOnlineStatusResponseModel {
  String onlineStatus;

  TeacherOnlineStatusResponseModel({
    required this.onlineStatus,
  });

  factory TeacherOnlineStatusResponseModel.fromJson(
          Map<String, dynamic> json) =>
      TeacherOnlineStatusResponseModel(
        onlineStatus: json["onlineStatus"],
      );

  Map<String, dynamic> toJson() => {
        "onlineStatus": onlineStatus,
      };
}
