// To parse this JSON data, do
//
//     final getTeacherProfileResponse = getTeacherProfileResponseFromJson(jsonString);

import 'dart:convert';

GetTeacherProfileResponse getTeacherProfileResponseFromJson(String str) => GetTeacherProfileResponse.fromJson(json.decode(str));

String getTeacherProfileResponseToJson(GetTeacherProfileResponse data) => json.encode(data.toJson());

class GetTeacherProfileResponse {
  int teacherId;
  String fullName;
  String emailAddress;
  int age;
  double latitude;
  double longitude;
  String contactNumber;
  String country;
  String city;
  dynamic dateOfBirth;
  String gender;
  dynamic headline;
  String speciality;
  dynamic institute;
  dynamic location;
  dynamic education;
  String dateOfCompletion;
  dynamic description;
  String profilePicture;
  int yearOfExperience;
  String certification;
  String occupation;

  GetTeacherProfileResponse({
    required this.teacherId,
    required this.fullName,
    required this.emailAddress,
    required this.age,
    required this.latitude,
    required this.longitude,
    required this.contactNumber,
    required this.country,
    required this.city,
    required this.dateOfBirth,
    required this.gender,
    required this.headline,
    required this.speciality,
    required this.institute,
    required this.location,
    required this.education,
    required this.dateOfCompletion,
    required this.description,
    required this.profilePicture,
    required this.yearOfExperience,
    required this.certification,
    required this.occupation,
  });

  factory GetTeacherProfileResponse.fromJson(Map<String, dynamic> json) => GetTeacherProfileResponse(
    teacherId: json["teacherId"],
    fullName: json["fullName"] ?? "",
    emailAddress: json["emailAddress"],
    age: json["age"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    contactNumber: json["contactNumber"] ?? "",
    country: json["country"],
    city: json["city"],
    dateOfBirth: json["dateOfBirth"],
    gender: json["gender"],
    headline: json["headline"],
    speciality: json["speciality"],
    institute: json["institute"],
    location: json["location"],
    education: json["education"],
    dateOfCompletion: json["dateOfCompletion"],
    description: json["description"],
    profilePicture: json["profilePicture"],
    yearOfExperience: json["yearOfExperience"],
    certification: json["certification"],
    occupation: json["occupation"],
  );

  Map<String, dynamic> toJson() => {
    "teacherId": teacherId,
    "fullName": fullName,
    "emailAddress": emailAddress,
    "age": age,
    "latitude": latitude,
    "longitude": longitude,
    "contactNumber": contactNumber,
    "country": country,
    "city": city,
    "dateOfBirth": dateOfBirth,
    "gender": gender,
    "headline": headline,
    "speciality": speciality,
    "institute": institute,
    "location": location,
    "education": education,
    "dateOfCompletion": dateOfCompletion,
    "description": description,
    "profilePicture": profilePicture,
    "yearOfExperience": yearOfExperience,
    "certification": certification,
    "occupation": occupation,
  };
}
