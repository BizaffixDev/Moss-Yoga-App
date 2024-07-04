// To parse this JSON data, do
//
//     final paymentIntentResponseModel = paymentIntentResponseModelFromJson(jsonString);

import 'dart:convert';

PaymentIntentResponseModel paymentIntentResponseModelFromJson(String str) =>
    PaymentIntentResponseModel.fromJson(json.decode(str));

String paymentIntentResponseModelToJson(PaymentIntentResponseModel data) =>
    json.encode(data.toJson());

class PaymentIntentResponseModel {
  String paymentIntentId;
  String clientSecret;

  PaymentIntentResponseModel({
    required this.paymentIntentId,
    required this.clientSecret,
  });

  factory PaymentIntentResponseModel.fromJson(Map<String, dynamic> json) =>
      PaymentIntentResponseModel(
        paymentIntentId: json["paymentIntentId"],
        clientSecret: json["clientSecret"],
      );

  Map<String, dynamic> toJson() => {
        "paymentIntentId": paymentIntentId,
        "clientSecret": clientSecret,
      };
}
