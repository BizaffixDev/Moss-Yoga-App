// To parse this JSON data, do
//
//     final rescheduleSessionRequest = rescheduleSessionRequestFromJson(jsonString);

import 'dart:convert';

RescheduleSessionRequest rescheduleSessionRequestFromJson(String str) => RescheduleSessionRequest.fromJson(json.decode(str));

String rescheduleSessionRequestToJson(RescheduleSessionRequest data) => json.encode(data.toJson());

class RescheduleSessionRequest {
  String bookingCode;
  int studentId;
  String teacherSchedulingDetailCode;
  String bookingDate;
  int paymentId;

  RescheduleSessionRequest({
    required this.bookingCode,
    required this.studentId,
    required this.teacherSchedulingDetailCode,
    required this.bookingDate,
    required this.paymentId,
  });

  factory RescheduleSessionRequest.fromJson(Map<String, dynamic> json) => RescheduleSessionRequest(
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
