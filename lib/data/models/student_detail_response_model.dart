// To parse this JSON data, do
//
//     final studentDetailResponseResponse = studentDetailResponseResponseFromJson(jsonString);

import 'dart:convert';

StudentDetailResponse studentDetailResponseResponseFromJson(String str) => StudentDetailResponse.fromJson(json.decode(str));

String studentDetailResponseResponseToJson(StudentDetailResponse data) => json.encode(data.toJson());

class StudentDetailResponse {

  String message;

  StudentDetailResponse({
    required this.message,
  });

  factory StudentDetailResponse.fromJson(Map<String, dynamic> json) => StudentDetailResponse(

    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
