// To parse this JSON data, do
//
//     final earningsTeacherResponse = earningsTeacherResponseFromJson(jsonString);

import 'dart:convert';

EarningsTeacherResponse earningsTeacherResponseFromJson(String str) => EarningsTeacherResponse.fromJson(json.decode(str));

String earningsTeacherResponseToJson(EarningsTeacherResponse data) => json.encode(data.toJson());

class EarningsTeacherResponse {
  String teacherId;
  int totalEarnings;
  List<Detail> details;

  EarningsTeacherResponse({
    required this.teacherId,
    required this.totalEarnings,
    required this.details,
  });

  factory EarningsTeacherResponse.fromJson(Map<String, dynamic> json) => EarningsTeacherResponse(
    teacherId: json["teacherId"],
    totalEarnings: json["totalEarnings"],
    details: List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "teacherId": teacherId,
    "totalEarnings": totalEarnings,
    "details": List<dynamic>.from(details.map((x) => x.toJson())),
  };
}

class Detail {
  String amount;
  String studentName;
  String paymentDate;
  String studentId;

  Detail({
    required this.amount,
    required this.studentName,
    required this.paymentDate,
    required this.studentId,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    amount: json["amount"],
    studentName: json["studentName"],
    paymentDate: json["paymentDate"],
    studentId: json["studentId"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "studentName": studentName,
    "paymentDate": paymentDate,
    "studentId": studentId,
  };
}
