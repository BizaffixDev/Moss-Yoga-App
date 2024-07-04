// To parse this JSON data, do
//
//     final updateStudentProfileResponse = updateStudentProfileResponseFromJson(jsonString);

import 'dart:convert';

UpdateStudentProfileRequest updateStudentProfileResponseFromJson(String str) => UpdateStudentProfileRequest.fromJson(json.decode(str));

String updateStudentProfileResponseToJson(UpdateStudentProfileRequest data) => json.encode(data.toJson());

class UpdateStudentProfileRequest {

  int userId;
  String userIntentions;
  String userLevel;
  List<String> userChronicalCondition;
  List<String> userPhysicalCondition;
  String haveInjury;
  String genderId;
  String trauma;
  String phoneNum;
  String occupation;
  String country;
  String city;
  String dob;
  String placeOfBirth;
  String chronicalOthers;
  String physicalOthers;

  UpdateStudentProfileRequest({
    required this.userId,
    required this.userIntentions,
    required this.userLevel,
    required this.userChronicalCondition,
    required this.userPhysicalCondition,
    required this.haveInjury,
    required this.genderId,
    required this.trauma,
    required this.phoneNum,
    required this.occupation,
    required this.country,
    required this.city,
    required this.dob,
    required this.placeOfBirth,
    required this.chronicalOthers,
    required this.physicalOthers,
  });

  factory UpdateStudentProfileRequest.fromJson(Map<String, dynamic> json) => UpdateStudentProfileRequest(
    userId: json["userId"],
    userIntentions: json["userIntentions"],
    userLevel: json["userLevel"],
    userChronicalCondition: List<String>.from(json["userChronicalCondition"].map((x) => x)),
    userPhysicalCondition: List<String>.from(json["userPhysicalCondition"].map((x) => x)),
    haveInjury: json["haveInjury"],
    genderId: json["genderId"],
    trauma: json["trauma"],
    phoneNum: json["phoneNum"],
    occupation: json["occupation"],
    country: json["country"],
    city: json["city"],
    dob: json["dob"],
    placeOfBirth: json["placeOfBirth"],
    chronicalOthers: json["chronicalOthers"],
    physicalOthers: json["physicalOthers"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "userIntentions": userIntentions,
    "userLevel": userLevel,
    "userChronicalCondition": List<dynamic>.from(userChronicalCondition.map((x) => x)),
    "userPhysicalCondition": List<dynamic>.from(userPhysicalCondition.map((x) => x)),
    "haveInjury": haveInjury,
    "genderId": genderId,
    "trauma": trauma,
    "phoneNum": phoneNum,
    "occupation": occupation,
    "country": country,
    "city": city,
    "dob": dob,
    "placeOfBirth": placeOfBirth,
    "chronicalOthers": chronicalOthers,
    "physicalOthers": physicalOthers,
  };
}
