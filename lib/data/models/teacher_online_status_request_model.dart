// To parse this JSON data, do
//
//     final teacherOnlineStatusRequestModel = teacherOnlineStatusRequestModelFromJson(jsonString);

import 'dart:convert';

TeacherOnlineStatusRequestModel teacherOnlineStatusRequestModelFromJson(
        String str) =>
    TeacherOnlineStatusRequestModel.fromJson(json.decode(str));

String teacherOnlineStatusRequestModelToJson(
        TeacherOnlineStatusRequestModel data) =>
    json.encode(data.toJson());

class TeacherOnlineStatusRequestModel {
  int userId;
  bool onlineStatus;

  TeacherOnlineStatusRequestModel({
    required this.userId,
    required this.onlineStatus,
  });

  factory TeacherOnlineStatusRequestModel.fromJson(Map<String, dynamic> json) =>
      TeacherOnlineStatusRequestModel(
        userId: json["userId"],
        onlineStatus: json["onlineStatus"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "onlineStatus": onlineStatus,
      };
}
