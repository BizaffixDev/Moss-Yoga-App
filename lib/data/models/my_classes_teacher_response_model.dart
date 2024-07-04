// To parse this JSON data, do
//
//     final myClassesStudentResponse = myClassesStudentResponseFromJson(jsonString);

import 'dart:convert';

MyClassesTeacherResponse myClassesTeacherResponseFromJson(String str) => MyClassesTeacherResponse.fromJson(json.decode(str));

String myClassesTeacherResponseToJson(MyClassesTeacherResponse data) => json.encode(data.toJson());

class MyClassesTeacherResponse {
  List<ClassesData> upcoming;
  List<ClassesData> cancelled;
  List<ClassesData> confirmed;

  MyClassesTeacherResponse({
    required this.upcoming,
    required this.cancelled,
    required this.confirmed,
  });

  factory MyClassesTeacherResponse.fromJson(Map<String, dynamic> json) => MyClassesTeacherResponse(
    upcoming: List<ClassesData>.from(json["upcoming"].map((x) => ClassesData.fromJson(x))),
    cancelled: List<ClassesData>.from(json["cancelled"].map((x) => ClassesData.fromJson(x))),
    confirmed: List<ClassesData>.from(json["confirmed"].map((x) => ClassesData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "upcoming": List<dynamic>.from(upcoming.map((x) => x.toJson())),
    "cancelled": List<dynamic>.from(cancelled.map((x) => x.toJson())),
    "confirmed": List<dynamic>.from(confirmed.map((x) => x.toJson())),
  };
}

class ClassesData {
  String teacherEmail;
  String teacherName;
  int teacherId;
  String tGender;
  String tHeadline;
  String tPic;
  int tAge;
  String teacherSchedulingDetailCode;
  String teacherSpeciality;
  String bookingType;
  int bookingStatus;
  String statusType;
  String bookingDate;
  String bookingDay;
  String bookingCode;
  int studentId;
  String price;
  String slotTime;
  String startTime;
  String endTime;
  String badgeName;
  String studentEmail;
  String studentName;

  ClassesData({
    required this.teacherEmail,
    required this.teacherName,
    required this.teacherId,
    required this.tGender,
    required this.tHeadline,
    required this.tPic,
    required this.tAge,
    required this.teacherSchedulingDetailCode,
    required this.teacherSpeciality,
    required this.bookingType,
    required this.bookingStatus,
    required this.statusType,
    required this.bookingDate,
    required this.bookingDay,
    required this.bookingCode,
    required this.studentId,
    required this.price,
    required this.slotTime,
    required this.startTime,
    required this.endTime,
    required this.badgeName,
    required this.studentEmail,
    required this.studentName,
  });

  factory ClassesData.fromJson(Map<String, dynamic> json) => ClassesData(
    teacherEmail: json["teacherEmail"],
    teacherName: json["teacherName"],
    teacherId: json["teacherId"],
    tGender: json["t_Gender"],
    tHeadline: json["t_Headline"],
    tPic: json["t_Pic"],
    tAge: json["t_Age"],
    teacherSchedulingDetailCode: json["teacherSchedulingDetailCode"],
    teacherSpeciality: json["teacherSpeciality"],
    bookingType: json["bookingType"],
    bookingStatus: json["bookingStatus"],
    statusType: json["statusType"],
    bookingDate: json["bookingDate"],
    bookingDay: json["bookingDay"],
    bookingCode: json["bookingCode"],
    studentId: json["studentId"],
    price: json["price"],
    slotTime: json["slotTime"],
    startTime: json["startTime"],
    endTime: json["endTime"],
    badgeName: json["badgeName"],
    studentEmail: json["studentEmail"],
    studentName: json["studentName"],
  );

  Map<String, dynamic> toJson() => {
    "teacherEmail": teacherEmail,
    "teacherName": teacherName,
    "teacherId": teacherId,
    "t_Gender": tGender,
    "t_Headline": tHeadline,
    "t_Pic": tPic,
    "t_Age": tAge,
    "teacherSchedulingDetailCode": teacherSchedulingDetailCode,
    "teacherSpeciality": teacherSpeciality,
    "bookingType": bookingType,
    "bookingStatus": bookingStatus,
    "statusType": statusType,
    "bookingDate": bookingDate,
    "bookingDay": bookingDay,
    "bookingCode": bookingCode,
    "studentId": studentId,
    "price": price,
    "slotTime": slotTime,
    "startTime": startTime,
    "endTime": endTime,
    "badgeName": badgeName,
    "studentEmail": studentEmail,
    "studentName": studentName,
  };
}
