// To parse this JSON data, do
//
//     final youMayAlsoLikeReponse = youMayAlsoLikeReponseFromJson(jsonString);

import 'dart:convert';

YouMayAlsoLikeReponse youMayAlsoLikeReponseFromJson(String str) => YouMayAlsoLikeReponse.fromJson(json.decode(str));

String youMayAlsoLikeReponseToJson(YouMayAlsoLikeReponse data) => json.encode(data.toJson());

class YouMayAlsoLikeReponse {
  List<String> message;

  YouMayAlsoLikeReponse({
    required this.message,
  });

  factory YouMayAlsoLikeReponse.fromJson(Map<String, dynamic> json) => YouMayAlsoLikeReponse(
    message: List<String>.from(json["message"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "message": List<dynamic>.from(message.map((x) => x)),
  };
}
