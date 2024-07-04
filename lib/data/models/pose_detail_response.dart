// To parse this JSON data, do
//
//     final getPoseDetailsResponse = getPoseDetailsResponseFromJson(jsonString);

import 'dart:convert';

GetPoseDetailsResponse getPoseDetailsResponseFromJson(String str) => GetPoseDetailsResponse.fromJson(json.decode(str));

String getPoseDetailsResponseToJson(GetPoseDetailsResponse data) => json.encode(data.toJson());

class GetPoseDetailsResponse {
  int poseId;
  String poseName;
  String poseImage;
  String poseShortDescription;
  String poseDescription;
  List<PoseDetailDescription> detailDescription;

  GetPoseDetailsResponse({
    required this.poseId,
    required this.poseName,
    required this.poseImage,
    required this.poseShortDescription,
    required this.poseDescription,
    required this.detailDescription,
  });

  factory GetPoseDetailsResponse.fromJson(Map<String, dynamic> json) => GetPoseDetailsResponse(
    poseId: json["poseId"],
    poseName: json["poseName"],
    poseImage: json["poseImage"],
    poseShortDescription: json["poseShortDescription"],
    poseDescription: json["poseDescription"],
    detailDescription: List<PoseDetailDescription>.from(json["detailDescription"].map((x) => PoseDetailDescription.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "poseId": poseId,
    "poseName": poseName,
    "poseImage": poseImage,
    "poseShortDescription": poseShortDescription,
    "poseDescription": poseDescription,
    "detailDescription": List<dynamic>.from(detailDescription.map((x) => x.toJson())),
  };
}

class PoseDetailDescription {
  String header;
  String detail;

  PoseDetailDescription({
    required this.header,
    required this.detail,
  });

  factory PoseDetailDescription.fromJson(Map<String, dynamic> json) => PoseDetailDescription(
    header: json["header"],
    detail: json["detail"],
  );

  Map<String, dynamic> toJson() => {
    "header": header,
    "detail": detail,
  };
}
