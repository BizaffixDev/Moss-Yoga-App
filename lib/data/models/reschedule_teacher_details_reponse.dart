// To parse this JSON data, do
//
//     final rescheduleTeacherDetailsResponse = rescheduleTeacherDetailsResponseFromJson(jsonString);

import 'dart:convert';

RescheduleTeacherDetailsResponse rescheduleTeacherDetailsResponseFromJson(String str) => RescheduleTeacherDetailsResponse.fromJson(json.decode(str));

String rescheduleTeacherDetailsResponseToJson(RescheduleTeacherDetailsResponse data) => json.encode(data.toJson());

class RescheduleTeacherDetailsResponse {
  List<Response> response;

  RescheduleTeacherDetailsResponse({
    required this.response,
  });

  factory RescheduleTeacherDetailsResponse.fromJson(Map<String, dynamic> json) => RescheduleTeacherDetailsResponse(
    response: List<Response>.from(json["response"].map((x) => Response.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "response": List<dynamic>.from(response.map((x) => x.toJson())),
  };
}

class Response {
  int teacherId;
  String slotTime;
  String price;
  String availableDates;
  String startTime;
  String endTime;
  String teacherUsername;
  String teacherFullName;
  String city;
  String country;
  int age;
  String gender;
  String headline;
  String speciality;
  int yearOfExperience;
  String occupation;
  String profilePicture;

  Response({
    required this.teacherId,
    required this.slotTime,
    required this.price,
    required this.availableDates,
    required this.startTime,
    required this.endTime,
    required this.teacherUsername,
    required this.teacherFullName,
    required this.city,
    required this.country,
    required this.age,
    required this.gender,
    required this.headline,
    required this.speciality,
    required this.yearOfExperience,
    required this.occupation,
    required this.profilePicture,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    teacherId: json["teacherId"],
    slotTime: json["slotTime"],
    price: json["price"],
    availableDates: json["availableDates"],
    startTime: json["startTime"],
    endTime: json["endTime"],
    teacherUsername: json["teacherUsername"],
    teacherFullName: json["teacherFullName"],
    city: json["city"],
    country: json["country"],
    age: json["age"],
    gender: json["gender"],
    headline: json["headline"],
    speciality: json["speciality"],
    yearOfExperience: json["yearOfExperience"],
    occupation: json["occupation"],
    profilePicture: json["profilePicture"],
  );

  Map<String, dynamic> toJson() => {
    "teacherId": teacherId,
    "slotTime": slotTime,
    "price": price,
    "availableDates": availableDates,
    "startTime": startTime,
    "endTime": endTime,
    "teacherUsername": teacherUsername,
    "teacherFullName": teacherFullName,
    "city": city,
    "country": country,
    "age": age,
    "gender": gender,
    "headline": headline,
    "speciality": speciality,
    "yearOfExperience": yearOfExperience,
    "occupation": occupation,
    "profilePicture": profilePicture,
  };
}
