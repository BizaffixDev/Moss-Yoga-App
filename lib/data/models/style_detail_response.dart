// To parse this JSON data, do
//
//     final getStyleDetailsResponse = getStyleDetailsResponseFromJson(jsonString);

import 'dart:convert';

GetStyleDetailsResponse getStyleDetailsResponseFromJson(String str) => GetStyleDetailsResponse.fromJson(json.decode(str));

String getStyleDetailsResponseToJson(GetStyleDetailsResponse data) => json.encode(data.toJson());

class GetStyleDetailsResponse {
  int styleId;
  String styleName;
  String styleImage;
  String styleShortDescription;
  String styleDescription;
  List<StyleDetailDescription> detailDescription;

  GetStyleDetailsResponse({
    required this.styleId,
    required this.styleName,
    required this.styleImage,
    required this.styleShortDescription,
    required this.styleDescription,
    required this.detailDescription,
  });

  factory GetStyleDetailsResponse.fromJson(Map<String, dynamic> json) => GetStyleDetailsResponse(
    styleId: json["styleId"],
    styleName: json["styleName"],
    styleImage: json["styleImage"],
    styleShortDescription: json["styleShortDescription"],
    styleDescription: json["styleDescription"],
    detailDescription: List<StyleDetailDescription>.from(json["detailDescription"].map((x) => StyleDetailDescription.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "styleId": styleId,
    "styleName": styleName,
    "styleImage": styleImage,
    "styleShortDescription": styleShortDescription,
    "styleDescription": styleDescription,
    "detailDescription": List<dynamic>.from(detailDescription.map((x) => x.toJson())),
  };
}

class StyleDetailDescription {
  String header;
  String detail;

  StyleDetailDescription({
    required this.header,
    required this.detail,
  });

  factory StyleDetailDescription.fromJson(Map<String, dynamic> json) => StyleDetailDescription(
    header: json["header"],
    detail: json["detail"],
  );

  Map<String, dynamic> toJson() => {
    "header": header,
    "detail": detail,
  };
}
