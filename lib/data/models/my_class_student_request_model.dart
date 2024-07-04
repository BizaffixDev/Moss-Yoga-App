// To parse this JSON data, do
//
//     final myClassStudentRequest = myClassStudentRequestFromJson(jsonString);

import 'dart:convert';

MyClassStudentRequest myClassStudentRequestFromJson(String str) => MyClassStudentRequest.fromJson(json.decode(str));

String myClassStudentRequestToJson(MyClassStudentRequest data) => json.encode(data.toJson());

class MyClassStudentRequest {
  String studentId;
  String date;

  MyClassStudentRequest({
    required this.studentId,
    required this.date,
  });

  factory MyClassStudentRequest.fromJson(Map<String, dynamic> json) => MyClassStudentRequest(
    studentId: json["studentId"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "studentId": studentId,
    "date": date,
  };
}
