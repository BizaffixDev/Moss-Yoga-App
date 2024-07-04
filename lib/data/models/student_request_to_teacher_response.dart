// To parse this JSON data, do
//
//     final studentRequestsToTeacherResponse = studentRequestsToTeacherResponseFromJson(jsonString);

import 'dart:convert';

List<StudentRequestsToTeacherResponse> studentRequestsToTeacherResponseFromJson(String str) => List<StudentRequestsToTeacherResponse>.from(json.decode(str).map((x) => StudentRequestsToTeacherResponse.fromJson(x)));

String studentRequestsToTeacherResponseToJson(List<StudentRequestsToTeacherResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StudentRequestsToTeacherResponse {
  String studentName;
  String email;
  String createdDate;
  String bookingCode;

  StudentRequestsToTeacherResponse({
    required this.studentName,
    required this.email,
    required this.createdDate,
    required this.bookingCode,
  });

  factory StudentRequestsToTeacherResponse.fromJson(Map<String, dynamic> json) => StudentRequestsToTeacherResponse(
    studentName: json["studentName"],
    email: json["email"],
    createdDate: json["createdDate"],
    bookingCode: json["bookingCode"],
  );

  Map<String, dynamic> toJson() => {
    "studentName": studentName,
    "email": email,
    "createdDate": createdDate,
    "bookingCode": bookingCode,
  };
}
