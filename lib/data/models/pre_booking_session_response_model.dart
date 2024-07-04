// To parse this JSON data, do
//
//     final preBookingSessionResponse = preBookingSessionResponseFromJson(jsonString);

import 'dart:convert';

PreBookingSessionResponse preBookingSessionResponseFromJson(String str) => PreBookingSessionResponse.fromJson(json.decode(str));

String preBookingSessionResponseToJson(PreBookingSessionResponse data) => json.encode(data.toJson());

class PreBookingSessionResponse {
  String bookingCode;
  String response;

  PreBookingSessionResponse({
    required this.bookingCode,
    required this.response,
  });

  factory PreBookingSessionResponse.fromJson(Map<String, dynamic> json) => PreBookingSessionResponse(
    bookingCode: json["bookingCode"],
    response: json["response"],
  );

  Map<String, dynamic> toJson() => {
    "bookingCode": bookingCode,
    "response": response,
  };
}
