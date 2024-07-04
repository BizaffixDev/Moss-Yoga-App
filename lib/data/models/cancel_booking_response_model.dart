// To parse this JSON data, do
//
//     final preBookingSessionResponse = preBookingSessionResponseFromJson(jsonString);

import 'dart:convert';

CancelBookingResponse cancelBookingResponseFromJson(String str) => CancelBookingResponse.fromJson(json.decode(str));

String cancelBookingResponseToJson(CancelBookingResponse data) => json.encode(data.toJson());

class CancelBookingResponse {
  String message;

  CancelBookingResponse({
    required this.message,
  });

  factory CancelBookingResponse.fromJson(Map<String, dynamic> json) => CancelBookingResponse(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
