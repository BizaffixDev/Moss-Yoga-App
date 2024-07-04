// To parse this JSON data, do
//
//     final teacherBookSessionRequestStudentModel = teacherBookSessionRequestStudentModelFromJson(jsonString);

import 'dart:convert';

TeacherBookSessionRequestStudentModel
    teacherBookSessionRequestStudentModelFromJson(String str) =>
        TeacherBookSessionRequestStudentModel.fromJson(json.decode(str));

String teacherBookSessionRequestStudentModelToJson(
        TeacherBookSessionRequestStudentModel data) =>
    json.encode(data.toJson());

class TeacherBookSessionRequestStudentModel {
  String bookingCode;

  TeacherBookSessionRequestStudentModel({
    required this.bookingCode,
  });

  factory TeacherBookSessionRequestStudentModel.fromJson(
          Map<String, dynamic> json) =>
      TeacherBookSessionRequestStudentModel(
        bookingCode: json["bookingCode"],
      );

  Map<String, dynamic> toJson() => {
        "bookingCode": bookingCode,
      };
}
