// To parse this JSON data, do
//
//     final getTeacherNoOfSessionResponseModel = getTeacherNoOfSessionResponseModelFromJson(jsonString);

import 'dart:convert';

GetTeacherNoOfSessionResponseModel getTeacherNoOfSessionResponseModelFromJson(
        String str) =>
    GetTeacherNoOfSessionResponseModel.fromJson(json.decode(str));

String getTeacherNoOfSessionResponseModelToJson(
        GetTeacherNoOfSessionResponseModel data) =>
    json.encode(data.toJson());

class GetTeacherNoOfSessionResponseModel {
  int spendHours;
  int totalHours;
  int sessionCount;

  GetTeacherNoOfSessionResponseModel({
    required this.spendHours,
    required this.totalHours,
    required this.sessionCount,
  });

  factory GetTeacherNoOfSessionResponseModel.fromJson(
          Map<String, dynamic> json) =>
      GetTeacherNoOfSessionResponseModel(
        spendHours: json["spendHours"],
        totalHours: json["totalHours"],
        sessionCount: json["sessionCount"],
      );

  Map<String, dynamic> toJson() => {
        "spendHours": spendHours,
        "totalHours": totalHours,
        "sessionCount": sessionCount,
      };
}
