// To parse this JSON data, do
//
//     final teacherDetailScheduleResponse = teacherDetailScheduleResponseFromJson(jsonString);

import 'dart:convert';

TeacherDetailScheduleResponse teacherDetailScheduleResponseFromJson(String str) => TeacherDetailScheduleResponse.fromJson(json.decode(str));

String teacherDetailScheduleResponseToJson(TeacherDetailScheduleResponse data) => json.encode(data.toJson());

class TeacherDetailScheduleResponse {
  int teacherId;
  List<Slot> slots;
  Availability availability;

  TeacherDetailScheduleResponse({
    required this.teacherId,
    required this.slots,
    required this.availability,
  });

  factory TeacherDetailScheduleResponse.fromJson(Map<String, dynamic> json) => TeacherDetailScheduleResponse(
    teacherId: json["teacherId"],
    slots: List<Slot>.from(json["slots"].map((x) => Slot.fromJson(x))),
    availability: Availability.fromJson(json["availability"]),
  );

  Map<String, dynamic> toJson() => {
    "teacherId": teacherId,
    "slots": List<dynamic>.from(slots.map((x) => x.toJson())),
    "availability": availability.toJson(),
  };
}

class Availability {
  List<String> availableDates;
  List<String> morning;
  List<dynamic> evening;
  List<dynamic> night;
  List<dynamic> afternoon;

  Availability({
    required this.availableDates,
    required this.morning,
    required this.evening,
    required this.night,
    required this.afternoon,
  });

  factory Availability.fromJson(Map<String, dynamic> json) => Availability(
    availableDates: List<String>.from(json["availableDates"].map((x) => x)),
    //List<DateTime>.from(json["availableDates"].map((x) => DateTime.parse(x))),
    morning: List<String>.from(json["morning"].map((x) => x)),
    evening: List<dynamic>.from(json["evening"].map((x) => x)),
    night: List<dynamic>.from(json["night"].map((x) => x)),
    afternoon: List<dynamic>.from(json["afternoon"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "availableDates": List<dynamic>.from(morning.map((x) => x)),
    //List<dynamic>.from(availableDates.map((x) => "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}")),
    "morning": List<dynamic>.from(morning.map((x) => x)),
    "evening": List<dynamic>.from(evening.map((x) => x)),
    "night": List<dynamic>.from(night.map((x) => x)),
    "afternoon": List<dynamic>.from(afternoon.map((x) => x)),
  };
}

class Slot {
  String slotTime;
  String price;
  String teacherSchedulingDetailCode;

  Slot({
    required this.slotTime,
    required this.price,
    required this.teacherSchedulingDetailCode,
  });

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
    slotTime: json["slotTime"],
    price: json["price"],
    teacherSchedulingDetailCode: json["teacherSchedulingDetailCode"],
  );

  Map<String, dynamic> toJson() => {
    "slotTime": slotTime,
    "price": price,
    "teacherSchedulingDetailCode": teacherSchedulingDetailCode,
  };
}
