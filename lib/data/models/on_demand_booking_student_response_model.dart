// To parse this JSON data, do
//
//     final onDemandBookingStudentResponseModel = onDemandBookingStudentResponseModelFromJson(jsonString);

import 'dart:convert';

OnDemandBookingStudentResponseModel onDemandBookingStudentResponseModelFromJson(String str) => OnDemandBookingStudentResponseModel.fromJson(json.decode(str));

String onDemandBookingStudentResponseModelToJson(OnDemandBookingStudentResponseModel data) => json.encode(data.toJson());

class OnDemandBookingStudentResponseModel {
  String bookingCode;
  String response;

  OnDemandBookingStudentResponseModel({
    required this.bookingCode,
    required this.response,
  });

  factory OnDemandBookingStudentResponseModel.fromJson(Map<String, dynamic> json) => OnDemandBookingStudentResponseModel(
    bookingCode: json["bookingCode"],
    response: json["response"],
  );

  Map<String, dynamic> toJson() => {
    "bookingCode": bookingCode,
    "response": response,
  };
}
