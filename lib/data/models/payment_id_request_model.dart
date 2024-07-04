// To parse this JSON data, do
//
//     final paymentIdRequestModel = paymentIdRequestModelFromJson(jsonString);

import 'dart:convert';

PaymentIdRequestModel paymentIdRequestModelFromJson(String str) =>
    PaymentIdRequestModel.fromJson(json.decode(str));

String paymentIdRequestModelToJson(PaymentIdRequestModel data) =>
    json.encode(data.toJson());

class PaymentIdRequestModel {
  String paymentIntentId;
  int studentId;
  int teacherId;
  int paymentType;
  String description;
  String teacherSchedulingDetailCode;
  String bookingDate;

  PaymentIdRequestModel({
    required this.paymentIntentId,
    required this.studentId,
    required this.teacherId,
    required this.paymentType,
    required this.description,
    required this.teacherSchedulingDetailCode,
    required this.bookingDate,
  });

  factory PaymentIdRequestModel.fromJson(Map<String, dynamic> json) =>
      PaymentIdRequestModel(
        paymentIntentId: json["paymentIntentId"],
        studentId: json["studentId"],
        teacherId: json["teacherId"],
        paymentType: json["paymentType"],
        description: json["description"],
        teacherSchedulingDetailCode: json["teacherSchedulingDetailCode"],
        bookingDate: json["bookingDate"],
      );

  Map<String, dynamic> toJson() => {
        "paymentIntentId": paymentIntentId,
        "studentId": studentId,
        "teacherId": teacherId,
        "paymentType": paymentType,
        "description": description,
        "teacherSchedulingDetailCode": teacherSchedulingDetailCode,
        "bookingDate": bookingDate,
      };
}
