// To parse this JSON data, do
//
//     final bookingAcceptedRejectedResponse = bookingAcceptedRejectedResponseFromJson(jsonString);

import 'dart:convert';

BookingAcceptedRejectedResponse bookingAcceptedRejectedResponseFromJson(String str) => BookingAcceptedRejectedResponse.fromJson(json.decode(str));

String bookingAcceptedRejectedResponseToJson(BookingAcceptedRejectedResponse data) => json.encode(data.toJson());

class BookingAcceptedRejectedResponse {
  String message;

  BookingAcceptedRejectedResponse({
    required this.message,
  });

  factory BookingAcceptedRejectedResponse.fromJson(Map<String, dynamic> json) => BookingAcceptedRejectedResponse(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
