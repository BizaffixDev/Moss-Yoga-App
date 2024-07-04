// To parse this JSON data, do
//
//     final getTeacherOndemandOnlineResponseModel = getTeacherOndemandOnlineResponseModelFromJson(jsonString);

import 'dart:convert';

GetTeacherOndemandOnlineResponseModel
    getTeacherOndemandOnlineResponseModelFromJson(String str) =>
        GetTeacherOndemandOnlineResponseModel.fromJson(json.decode(str));

String getTeacherOndemandOnlineResponseModelToJson(
        GetTeacherOndemandOnlineResponseModel data) =>
    json.encode(data.toJson());

class GetTeacherOndemandOnlineResponseModel {
  bool message;

  GetTeacherOndemandOnlineResponseModel({
    required this.message,
  });

  factory GetTeacherOndemandOnlineResponseModel.fromJson(
          Map<String, dynamic> json) =>
      GetTeacherOndemandOnlineResponseModel(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}
