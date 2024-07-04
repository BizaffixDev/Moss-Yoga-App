// To parse this JSON data, do
//
//     final studentProfileDetailReponse = studentProfileDetailReponseFromJson(jsonString);

import 'dart:convert';

StudentProfileDetailReponse studentProfileDetailReponseFromJson(String str) => StudentProfileDetailReponse.fromJson(json.decode(str));

String studentProfileDetailReponseToJson(StudentProfileDetailReponse data) => json.encode(data.toJson());

class StudentProfileDetailReponse {
  int userId;
  String studentName;
  bool isActive;
  String studentEmail;
  String city;
  String country;
  String dateOfBirth;
  String occupation;
  String phoneNumber;
  String placeOfBirth;
  String chronicalOthers;
  String userIntentions;
  String userLevel;
  String trauma;
  String userPhysicalCondition;
  String userChronicalCondition;
  String physicalOthers;
  String gender;

  StudentProfileDetailReponse({
    required this.userId,
    required this.studentName,
    required this.isActive,
    required this.studentEmail,
    required this.city,
    required this.country,
    required this.dateOfBirth,
    required this.occupation,
    required this.phoneNumber,
    required this.placeOfBirth,
    required this.chronicalOthers,
    required this.userIntentions,
    required this.userLevel,
    required this.trauma,
    required this.userPhysicalCondition,
    required this.userChronicalCondition,
    required this.physicalOthers,
    required this.gender,
  });

  factory StudentProfileDetailReponse.fromJson(Map<String, dynamic> json) => StudentProfileDetailReponse(
    userId: json["userId"],
    studentName: json["studentName"],
    isActive: json["isActive"],
    studentEmail: json["studentEmail"],
    city: json["city"],
    country: json["country"],
    dateOfBirth: json["dateOfBirth"],
    occupation: json["occupation"],
    phoneNumber: json["phoneNumber"],
    placeOfBirth: json["placeOfBirth"],
    chronicalOthers: json["chronicalOthers"],
    userIntentions: json["userIntentions"],
    userLevel: json["userLevel"],
    trauma: json["trauma"],
    userPhysicalCondition: json["userPhysicalCondition"],
    userChronicalCondition: json["userChronicalCondition"],
    physicalOthers: json["physicalOthers"],
    gender: json["gender"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "studentName": studentName,
    "isActive": isActive,
    "studentEmail": studentEmail,
    "city": city,
    "country": country,
    "dateOfBirth": dateOfBirth,
    "occupation": occupation,
    "phoneNumber": phoneNumber,
    "placeOfBirth": placeOfBirth,
    "chronicalOthers": chronicalOthers,
    "userIntentions": userIntentions,
    "userLevel": userLevel,
    "trauma": trauma,
    "userPhysicalCondition": userPhysicalCondition,
    "userChronicalCondition": userChronicalCondition,
    "physicalOthers": physicalOthers,
    "gender": gender,
  };
}
