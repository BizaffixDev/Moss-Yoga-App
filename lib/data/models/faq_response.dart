// To parse this JSON data, do
//
//     final faqsReponse = faqsReponseFromJson(jsonString);

import 'dart:convert';

List<FaqsReponse> faqsReponseFromJson(String str) => List<FaqsReponse>.from(json.decode(str).map((x) => FaqsReponse.fromJson(x)));

String faqsReponseToJson(List<FaqsReponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FaqsReponse {
  String question;
  String answer;

  FaqsReponse({
    required this.question,
    required this.answer,
  });

  factory FaqsReponse.fromJson(Map<String, dynamic> json) => FaqsReponse(
    question: json["question"],
    answer: json["answer"],
  );

  Map<String, dynamic> toJson() => {
    "question": question,
    "answer": answer,
  };
}
