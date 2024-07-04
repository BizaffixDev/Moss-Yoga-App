// To parse this JSON data, do
//
//     final topRatedTeacherResponseModel = topRatedTeacherResponseModelFromJson(jsonString);

import 'dart:convert';

List<PreviousTeachersResponseModel> previousTeacherResponseModelFromJson(String str) => List<PreviousTeachersResponseModel>.from(json.decode(str).map((x) => PreviousTeachersResponseModel.fromJson(x)));

String previousTeacherResponseModelToJson(List<PreviousTeachersResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PreviousTeachersResponseModel {
  int teacherId;
  String teacherFirstName;
  //String teacherLastName;
  String occupation;
  String teacherSpeciality;
  String teacherHeadline;
  String badgeName;
  String startTime;
  String endTime;
  String availableDates;
  String slotTime;
  String price;
  String teacherSchedulingDetailCode;
  String gender;
  String profilePicture;
  String city;
  String maxRatingValue;
  String minRatingValue;
  String avgRatingValue;
  String ratingCount;

  PreviousTeachersResponseModel({
    required this.teacherId,
    required this.teacherFirstName,
    //required this.teacherLastName,
    required this.occupation,
    required this.teacherSpeciality,
    required this.teacherHeadline,
    required this.badgeName,
    required this.startTime,
    required this.endTime,
    required this.availableDates,
    required this.slotTime,
    required this.price,
    required this.teacherSchedulingDetailCode,
    required this.gender,
    required this.profilePicture,
    required this.city,
    required this.maxRatingValue,
    required this.minRatingValue,
    required this.avgRatingValue,
    required this.ratingCount,
  });

  factory PreviousTeachersResponseModel.fromJson(Map<String, dynamic> json) => PreviousTeachersResponseModel(
    teacherId: json["teacherId"],
    teacherFirstName: json["teacherFirstName"],
    //teacherLastName: json["teacherLastName"],
    occupation: json["occupation"],
    teacherSpeciality: json["teacherSpeciality"],
    teacherHeadline: json["teacherHeadline"],
    badgeName: json["badgeName"],
    startTime: json["startTime"],
    endTime: json["endTime"],
    availableDates:json["availableDates"],
    //DateTime.parse(json["availableDates"]),
    slotTime: json["slotTime"],
    price: json["price"],
    teacherSchedulingDetailCode: json["teacherSchedulingDetailCode"],
    gender: json["gender"],
    profilePicture: json["profilePicture"],
    city: json["city"],
    maxRatingValue: json["maxRatingValue"],
    //maxRatingValue: json["maxRatingValue"]?.toDouble(),
    minRatingValue: json["minRatingValue"],
    //minRatingValue: json["minRatingValue"],
    avgRatingValue: json["avgRatingValue"],
    //avgRatingValue: json["avgRatingValue"]?.toDouble(),
    ratingCount: json["ratingCount"],
  );

  Map<String, dynamic> toJson() => {
    "teacherId": teacherId,
    "teacherFirstName": teacherFirstName,
    //"teacherLastName": teacherLastName,
    "occupation": occupation,
    "teacherSpeciality": teacherSpeciality,
    "teacherHeadline": teacherHeadline,
    "badgeName": badgeName,
    "startTime": startTime,
    "endTime": endTime,
    "availableDates": availableDates,
    "slotTime": slotTime,
    "price": price,
    "teacherSchedulingDetailCode": teacherSchedulingDetailCode,
    "gender": gender,
    "profilePicture": profilePicture,
    "city": city,
    "maxRatingValue": maxRatingValue,
    "minRatingValue": minRatingValue,
    "avgRatingValue": avgRatingValue,
    "ratingCount": ratingCount,
  };
}
