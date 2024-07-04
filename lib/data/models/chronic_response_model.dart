// To parse this JSON data, do
//
//     final chronicResponseModel = chronicResponseModelFromJson(jsonString);

import 'dart:convert';

List<ChronicResponseModel> chronicResponseModelFromJson(String str) => List<ChronicResponseModel>.from(json.decode(str).map((x) => ChronicResponseModel.fromJson(x)));

String chronicResponseModelToJson(List<ChronicResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChronicResponseModel {
  int chronicConditionId;
  String chronicConditionName;
  String cCDescription;
  bool isActive;

  ChronicResponseModel({

    required this.chronicConditionId,
    required this.chronicConditionName,
    required this.cCDescription,
    required this.isActive,

  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChronicResponseModel &&
        other.chronicConditionId == chronicConditionId &&
        other.chronicConditionName == chronicConditionName &&
        other.cCDescription == cCDescription &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return chronicConditionId.hashCode ^
    chronicConditionName.hashCode ^
    cCDescription.hashCode ^
    isActive.hashCode;
  }


  factory ChronicResponseModel.fromJson(Map<String, dynamic> json) => ChronicResponseModel(
    chronicConditionId: json["chronicConditionId"],
    chronicConditionName: json["chronicConditionName"],
    cCDescription: json["cC_Description"],
    isActive: json["isActive"],
  );

  Map<String, dynamic> toJson() => {
    "chronicConditionId": chronicConditionId,
    "chronicConditionName": chronicConditionName,
    "cC_Description": cCDescription,
    "isActive": isActive,
  };
}


class ChronicListResponse {
  final List<ChronicResponseModel> chronicList;
  ChronicListResponse({required this.chronicList});



  factory ChronicListResponse.fromJson(List<dynamic> json) {
    final chronicList = json.map((data) => ChronicResponseModel.fromJson(data)).toList();
    return ChronicListResponse(chronicList: chronicList);
  }
}
