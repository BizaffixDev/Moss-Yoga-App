// To parse this JSON data, do
//
//     final myClassStudentRequest = myClassStudentRequestFromJson(jsonString);

import 'dart:convert';

MyClassTeacherRequest myClassStudentRequestFromJson(String str) => MyClassTeacherRequest.fromJson(json.decode(str));

String myClassTeacherRequestToJson(MyClassTeacherRequest data) => json.encode(data.toJson());

class MyClassTeacherRequest {
  String teacherId;
  String date;

  MyClassTeacherRequest({
    required this.teacherId,
    required this.date,
  });

  factory MyClassTeacherRequest.fromJson(Map<String, dynamic> json) => MyClassTeacherRequest(
    teacherId: json["teacherId"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "teacherId": teacherId,
    "date": date,
  };
}
