// To parse this JSON data, do
//
//     final onDemandStudentBookingRequest = onDemandStudentBookingRequestFromJson(jsonString);

import 'dart:convert';

OnDemandStudentBookingRequest onDemandStudentBookingRequestFromJson(String str) => OnDemandStudentBookingRequest.fromJson(json.decode(str));

String onDemandStudentBookingRequestToJson(OnDemandStudentBookingRequest data) => json.encode(data.toJson());

class OnDemandStudentBookingRequest {
  int studentId;
  String teacherSchedulingDetailCode;
  String bookingDate;
  int paymentId;

  OnDemandStudentBookingRequest({
    required this.studentId,
    required this.teacherSchedulingDetailCode,
    required this.bookingDate,
    required this.paymentId,
  });

  factory OnDemandStudentBookingRequest.fromJson(Map<String, dynamic> json) => OnDemandStudentBookingRequest(
    studentId: json["studentId"],
    teacherSchedulingDetailCode: json["teacherSchedulingDetailCode"],
    bookingDate: json["bookingDate"],
    paymentId: json["paymentId"],
  );

  Map<String, dynamic> toJson() => {
    "studentId": studentId,
    "teacherSchedulingDetailCode": teacherSchedulingDetailCode,
    "bookingDate": bookingDate,
    "paymentId": paymentId,
  };
}
