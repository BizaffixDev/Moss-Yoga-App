// To parse this JSON data, do
//
//     final updateStudentProfileResponse = updateStudentProfileResponseFromJson(jsonString);

import 'dart:convert';

UpdateProfileResponse updateStudentProfileResponseFromJson(String str) => UpdateProfileResponse.fromJson(json.decode(str));

String updateStudentProfileResponseToJson(UpdateProfileResponse data) => json.encode(data.toJson());

class UpdateProfileResponse {
  String message;

  UpdateProfileResponse({
    required this.message,
  });

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) => UpdateProfileResponse(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
