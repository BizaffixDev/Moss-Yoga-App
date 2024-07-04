// To parse this JSON data, do
//
//     final rescheduleSessionResponse = rescheduleSessionResponseFromJson(jsonString);

import 'dart:convert';

RescheduleSessionResponse rescheduleSessionResponseFromJson(String str) => RescheduleSessionResponse.fromJson(json.decode(str));

String rescheduleSessionResponseToJson(RescheduleSessionResponse data) => json.encode(data.toJson());

class RescheduleSessionResponse {
  Request request;
  String response;

  RescheduleSessionResponse({
    required this.request,
    required this.response,
  });

  factory RescheduleSessionResponse.fromJson(Map<String, dynamic> json) => RescheduleSessionResponse(
    request: Request.fromJson(json["request"]),
    response: json["response"],
  );

  Map<String, dynamic> toJson() => {
    "request": request.toJson(),
    "response": response,
  };
}

class Request {
  String bookingCode;
  int studentId;
  String teacherSchedulingDetailCode;
  String bookingDate;
  int paymentId;

  Request({
    required this.bookingCode,
    required this.studentId,
    required this.teacherSchedulingDetailCode,
    required this.bookingDate,
    required this.paymentId,
  });

  factory Request.fromJson(Map<String, dynamic> json) => Request(
    bookingCode: json["bookingCode"],
    studentId: json["studentId"],
    teacherSchedulingDetailCode: json["teacherSchedulingDetailCode"],
    bookingDate: json["bookingDate"],
    paymentId: json["paymentId"],
  );

  Map<String, dynamic> toJson() => {
    "bookingCode": bookingCode,
    "studentId": studentId,
    "teacherSchedulingDetailCode": teacherSchedulingDetailCode,
    "bookingDate": bookingDate,
    "paymentId": paymentId,
  };
}
