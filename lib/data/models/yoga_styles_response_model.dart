// To parse this JSON data, do
//
//     final yogaStylesResponse = yogaStylesResponseFromJson(jsonString);


class YogaStylesListModel {
  List<YogaStylesResponseModel> styles;

  YogaStylesListModel({required this.styles});

  factory YogaStylesListModel.fromJson(List<dynamic> json) {
    List<YogaStylesResponseModel> styles =
        json.map((e) => YogaStylesResponseModel.fromJson(e)).toList();
    return YogaStylesListModel(styles: styles);
  }

  List<dynamic> toJson() {
    return styles.map((e) => e.toJson()).toList();
  }
}

class YogaStylesResponseModel {
  int styleId;
  String styleName;
  String styleImage;
  String styleShortDescription;
  String styleDescription;
  String createdDate;
  bool isActive;

  YogaStylesResponseModel({
    required this.styleId,
    required this.styleName,
    required this.styleImage,
    required this.styleShortDescription,
    required this.styleDescription,
    required this.createdDate,
    required this.isActive,
  });

  factory YogaStylesResponseModel.fromJson(Map<String, dynamic> json) =>
      YogaStylesResponseModel(
        styleId: json["styleId"],
        styleName: json["styleName"],
        styleImage: json["styleImage"],
        styleShortDescription: json["styleShortDescription"],
        styleDescription: json["styleDescription"],
        createdDate: json["createdDate"],
        isActive: json["isActive"],
      );

  Map<String, dynamic> toJson() => {
        "styleId": styleId,
        "styleName": styleName,
        "styleImage": styleImage,
        "styleShortDescription": styleShortDescription,
        "styleDescription": styleDescription,
        "createdDate": createdDate,
        "isActive": isActive,
      };
}
