// To parse this JSON data, do
//
//     final addScheduleTeacherRequest = addScheduleTeacherRequestFromJson(jsonString);

import 'dart:convert';

AddScheduleTeacherRequest addScheduleTeacherRequestFromJson(String str) => AddScheduleTeacherRequest.fromJson(json.decode(str));

String addScheduleTeacherRequestToJson(AddScheduleTeacherRequest data) => json.encode(data.toJson());

class AddScheduleTeacherRequest {
  int teacherId;
  List<String> availableDates;
  String startTime;
  String endTime;
  List<SetPricing> setPricing;

  AddScheduleTeacherRequest({
    required this.teacherId,
    required this.availableDates,
    required this.startTime,
    required this.endTime,
    required this.setPricing,
  });

  factory AddScheduleTeacherRequest.fromJson(Map<String, dynamic> json) => AddScheduleTeacherRequest(
    teacherId: json["teacherId"],
    availableDates: List<String>.from(json["availableDates"].map((x) => x)),
    startTime: json["startTime"],
    endTime: json["endTime"],
    setPricing: List<SetPricing>.from(json["setPricing"].map((x) => SetPricing.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "teacherId": teacherId,
    "availableDates": List<dynamic>.from(availableDates.map((x) => x)),
    "startTime": startTime,
    "endTime": endTime,
    "setPricing": List<dynamic>.from(setPricing.map((x) => x.toJson())),
  };
}

class SetPricing {
  String pricing;
  String slotTime;

  SetPricing({
    required this.pricing,
    required this.slotTime,
  });

  factory SetPricing.fromJson(Map<String, dynamic> json) => SetPricing(
    pricing: json["pricing"],
    slotTime: json["slotTime"],
  );

  Map<String, dynamic> toJson() => {
    "pricing": pricing,
    "slotTime": slotTime,
  };
}
