// To parse this JSON data, do
//
//     final addScheduleTeacherResponse = addScheduleTeacherResponseFromJson(jsonString);

import 'dart:convert';

AddScheduleTeacherResponse addScheduleTeacherResponseFromJson(String str) => AddScheduleTeacherResponse.fromJson(json.decode(str));

String addScheduleTeacherResponseToJson(AddScheduleTeacherResponse data) => json.encode(data.toJson());

class AddScheduleTeacherResponse {
  String message;

  AddScheduleTeacherResponse({
    required this.message,
  });

  factory AddScheduleTeacherResponse.fromJson(Map<String, dynamic> json) => AddScheduleTeacherResponse(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
