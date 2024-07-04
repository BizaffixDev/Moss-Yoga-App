// To parse this JSON data, do
//
//     final acceptRejectStudentRequestResponse = acceptRejectStudentRequestResponseFromJson(jsonString);

import 'dart:convert';

AcceptRejectStudentRequestResponse acceptRejectStudentRequestResponseFromJson(String str) => AcceptRejectStudentRequestResponse.fromJson(json.decode(str));

String acceptRejectStudentRequestResponseToJson(AcceptRejectStudentRequestResponse data) => json.encode(data.toJson());

class AcceptRejectStudentRequestResponse {
  String message;
  Data data;

  AcceptRejectStudentRequestResponse({
    required this.message,
    required this.data,
  });

  factory AcceptRejectStudentRequestResponse.fromJson(Map<String, dynamic> json) => AcceptRejectStudentRequestResponse(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  int teacherId;
  String price;

  Data({
    required this.teacherId,
    required this.price,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    teacherId: json["teacherId"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "teacherId": teacherId,
    "price": price,
  };
}
