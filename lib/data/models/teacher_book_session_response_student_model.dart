// To parse this JSON data, do
//
//     final teacherBookSessionResponseStudentModel = teacherBookSessionResponseStudentModelFromJson(jsonString);

import 'dart:convert';

TeacherBookSessionResponseStudentModel
    teacherBookSessionResponseStudentModelFromJson(String str) =>
        TeacherBookSessionResponseStudentModel.fromJson(json.decode(str));

String teacherBookSessionResponseStudentModelToJson(
        TeacherBookSessionResponseStudentModel data) =>
    json.encode(data.toJson());

class TeacherBookSessionResponseStudentModel {
  String message;
  Data data;

  TeacherBookSessionResponseStudentModel({
    required this.message,
    required this.data,
  });

  factory TeacherBookSessionResponseStudentModel.fromJson(
          Map<String, dynamic> json) =>
      TeacherBookSessionResponseStudentModel(
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  int teacherId;
  String price;

  Data({
    required this.teacherId,
    required this.price,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        teacherId: json["teacherId"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "teacherId": teacherId,
        "price": price,
      };
}
