// To parse this JSON data, do
//
//     final learnMossYogaReponse = learnMossYogaReponseFromJson(jsonString);

import 'dart:convert';

List<LearnMossYogaReponse> learnMossYogaReponseFromJson(String str) => List<LearnMossYogaReponse>.from(json.decode(str).map((x) => LearnMossYogaReponse.fromJson(x)));

String learnMossYogaReponseToJson(List<LearnMossYogaReponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LearnMossYogaReponse {
  String title;
  String description;

  LearnMossYogaReponse({
    required this.title,
    required this.description,
  });

  factory LearnMossYogaReponse.fromJson(Map<String, dynamic> json) => LearnMossYogaReponse(
    title: json["title"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
  };
}
