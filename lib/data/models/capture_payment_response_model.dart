// To parse this JSON data, do
//
//     final capturePaymentResponseModel = capturePaymentResponseModelFromJson(jsonString);

import 'dart:convert';

CapturePaymentResponseModel capturePaymentResponseModelFromJson(String str) =>
    CapturePaymentResponseModel.fromJson(json.decode(str));

String capturePaymentResponseModelToJson(CapturePaymentResponseModel data) =>
    json.encode(data.toJson());

class CapturePaymentResponseModel {
  String message;

  CapturePaymentResponseModel({
    required this.message,
  });

  factory CapturePaymentResponseModel.fromJson(Map<String, dynamic> json) =>
      CapturePaymentResponseModel(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}
