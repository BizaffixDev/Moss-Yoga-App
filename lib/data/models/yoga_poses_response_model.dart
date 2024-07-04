// To parse this JSON data, do
//
//     final PosesResponseModel = PosesResponseModelFromJson(jsonString);



class PosesListModel {
  List<PosesResponseModel> poses;

  PosesListModel({required this.poses});

  factory PosesListModel.fromJson(List<dynamic> json) {
    List<PosesResponseModel> poses = json.map((e) => PosesResponseModel.fromJson(e)).toList();
    return PosesListModel(poses: poses);
  }

  List<dynamic> toJson() {
    return poses.map((e) => e.toJson()).toList();
  }
}


class PosesResponseModel {
  int poseId;
  String poseName;
  String poseImage;
  String poseShortDescription;
  String poseDescription;
  String createdDate;
  bool isActive;

  PosesResponseModel({
    required this.poseId,
    required this.poseName,
    required this.poseImage,
    required this.poseShortDescription,
    required this.poseDescription,
    required this.createdDate,
    required this.isActive,
  });

  factory PosesResponseModel.fromJson(Map<String, dynamic> json) => PosesResponseModel(
    poseId: json["poseId"],
    poseName: json["poseName"],
    poseImage: json["poseImage"],
    poseShortDescription: json["poseShortDescription"],
    poseDescription: json["poseDescription"],
    createdDate: json["createdDate"],
    isActive: json["isActive"],
  );

  Map<String, dynamic> toJson() => {
    "poseId": poseId,
    "poseName": poseName,
    "poseImage": poseImage,
    "poseShortDescription": poseShortDescription,
    "poseDescription": poseDescription,
    "createdDate": createdDate,
    "isActive": isActive,
  };
}
