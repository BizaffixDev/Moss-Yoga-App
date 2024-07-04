// To parse this JSON data, do
//
//     final deleteAccountReponse = deleteAccountReponseFromJson(jsonString);

import 'dart:convert';

DeleteAccountReponse deleteAccountReponseFromJson(String str) => DeleteAccountReponse.fromJson(json.decode(str));

String deleteAccountReponseToJson(DeleteAccountReponse data) => json.encode(data.toJson());

class DeleteAccountReponse {
  String message;

  DeleteAccountReponse({
    required this.message,
  });

  factory DeleteAccountReponse.fromJson(Map<String, dynamic> json) => DeleteAccountReponse(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
