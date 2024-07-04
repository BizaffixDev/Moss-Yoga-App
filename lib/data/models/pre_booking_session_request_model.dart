// To parse this JSON data, do
//
//     final preBookingSessionRequest = preBookingSessionRequestFromJson(jsonString);

import 'dart:convert';

PreBookingSessionRequest preBookingSessionRequestFromJson(String str) => PreBookingSessionRequest.fromJson(json.decode(str));

String preBookingSessionRequestToJson(PreBookingSessionRequest data) => json.encode(data.toJson());

class PreBookingSessionRequest {
  int studentId;
  String teacherSchedulingDetailCode;
  String bookingDate;
  int paymentId;

  PreBookingSessionRequest({
    required this.studentId,
    required this.teacherSchedulingDetailCode,
    required this.bookingDate,
    required this.paymentId,
  });

  factory PreBookingSessionRequest.fromJson(Map<String, dynamic> json) => PreBookingSessionRequest(
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
