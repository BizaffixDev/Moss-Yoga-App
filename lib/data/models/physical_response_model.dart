// To parse this JSON data, do
//
//     final physicalResponseModel = physicalResponseModelFromJson(jsonString);

import 'dart:convert';

List<PhysicalResponseModel> physicalResponseModelFromJson(String str) => List<PhysicalResponseModel>.from(json.decode(str).map((x) => PhysicalResponseModel.fromJson(x)));

String physicalResponseModelToJson(List<PhysicalResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PhysicalResponseModel {
  int physicalInjuryId;
  String injuryName;
  String injuryDescription;
  bool isActive;

  PhysicalResponseModel({
    required this.physicalInjuryId,
    required this.injuryName,
    required this.injuryDescription,
    required this.isActive,
  });

  factory PhysicalResponseModel.fromJson(Map<String, dynamic> json) => PhysicalResponseModel(
    physicalInjuryId: json["physicalInjuryId"],
    injuryName: json["injuryName"],
    injuryDescription: json["injuryDescription"],
    isActive: json["isActive"],
  );

  Map<String, dynamic> toJson() => {
    "physicalInjuryId": physicalInjuryId,
    "injuryName": injuryName,
    "injuryDescription": injuryDescription,
    "isActive": isActive,
  };
}

class PhysicalListResponse {
  final List<PhysicalResponseModel> physicalList;
  PhysicalListResponse({required this.physicalList});



  factory PhysicalListResponse.fromJson(List<dynamic> json) {
    final physicalList = json.map((data) => PhysicalResponseModel.fromJson(data)).toList();
    return PhysicalListResponse(physicalList: physicalList);
  }
}
