// To parse this JSON data, do
//
//     final guideDetailResponse = guideDetailResponseFromJson(jsonString);

import 'dart:convert';

GuideDetailResponse guideDetailResponseFromJson(String str) => GuideDetailResponse.fromJson(json.decode(str));

String guideDetailResponseToJson(GuideDetailResponse data) => json.encode(data.toJson());

class GuideDetailResponse {
  int keyId;
  String name;
  String image;
  String shortDescription;
  String description;
  List<GuideAZDetailDescription> detailDescription;

  GuideDetailResponse({
    required this.keyId,
    required this.name,
    required this.image,
    required this.shortDescription,
    required this.description,
    required this.detailDescription,
  });

  factory GuideDetailResponse.fromJson(Map<String, dynamic> json) => GuideDetailResponse(
    keyId: json["keyId"],
    name: json["name"],
    image: json["image"],
    shortDescription: json["shortDescription"],
    description: json["description"],
    detailDescription: List<GuideAZDetailDescription>.from(json["detailDescription"].map((x) => GuideAZDetailDescription.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "keyId": keyId,
    "name": name,
    "image": image,
    "shortDescription": shortDescription,
    "description": description,
    "detailDescription": List<dynamic>.from(detailDescription.map((x) => x.toJson())),
  };
}

class GuideAZDetailDescription {
  String header;
  String detail;

  GuideAZDetailDescription({
    required this.header,
    required this.detail,
  });

  factory GuideAZDetailDescription.fromJson(Map<String, dynamic> json) => GuideAZDetailDescription(
    header: json["header"],
    detail: json["detail"],
  );

  Map<String, dynamic> toJson() => {
    "header": header,
    "detail": detail,
  };
}
