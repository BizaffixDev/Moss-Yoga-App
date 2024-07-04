// To parse this JSON data, do
//
//     final topRatedTeacherResponseModel = topRatedTeacherResponseModelFromJson(jsonString);

import 'dart:convert';

List<TopRatedTeacherResponseModel> topRatedTeacherResponseModelFromJson(String str) => List<TopRatedTeacherResponseModel>.from(json.decode(str).map((x) => TopRatedTeacherResponseModel.fromJson(x)));


class TopRatedTeacherResponseModel {
  String teacherSpeciality;
  String teacherHeadline;
  String city;
  int teacherId;
  String teacherFirstName;
  String occupation;
  String gender;
  String profilePicture;
  String maxRatingValue;
  String minRatingValue;
  String avgRatingValue;
  int ratingCount;
  String badgeName;
  List<TeacherSchedulingDetail> getDatesResponse;

  TopRatedTeacherResponseModel({
    required this.teacherSpeciality,
    required this.teacherHeadline,
    required this.city,
    required this.teacherId,
    required this.teacherFirstName,
    required this.occupation,
    required this.gender,
    required this.profilePicture,
    required this.maxRatingValue,
    required this.minRatingValue,
    required this.avgRatingValue,
    required this.ratingCount,
    required this.badgeName,
    required this.getDatesResponse,
  });

  factory TopRatedTeacherResponseModel.fromJson(Map<String, dynamic> json) {
    return TopRatedTeacherResponseModel(
      teacherSpeciality: json['teacherSpeciality'],
      teacherHeadline: json['teacherHeadline'],
      city: json['city'],
      teacherId: json['teacherId'],
      teacherFirstName: json['teacherFirstName'],
      occupation: json['occupation'],
      gender: json['gender'],
      profilePicture: json['profilePicture'],
      maxRatingValue: json['maxRatingValue'],
      minRatingValue: json['minRatingValue'],
      avgRatingValue: json['avgRatingValue'],
      ratingCount: int.parse(json['ratingCount']),
      badgeName: json['badgeName'],
      getDatesResponse: List<TeacherSchedulingDetail>.from(
        json['getDatesResponse'].map(
              (x) => TeacherSchedulingDetail.fromJson(x),
        ),
      ),
    );
  }
}

class TeacherSchedulingDetail {
  String teacherSchedulingDetailCode;
  String startTime;
  String availableDates;
  String endTime;
  String price;
  String slotTime;

  TeacherSchedulingDetail({
    required  this.teacherSchedulingDetailCode,
    required  this.startTime,
    required  this.availableDates,
    required  this.endTime,
    required  this.price,
    required  this.slotTime,
  });

  factory TeacherSchedulingDetail.fromJson(Map<String, dynamic> json) {
    return TeacherSchedulingDetail(
      teacherSchedulingDetailCode: json['teacherSchedulingDetailCode'],
      startTime: json['startTime'],
      availableDates: json['availableDates'],
      endTime: json['endTime'],
      price: json['price'],
      slotTime: json['slotTime'],
    );
  }
}
