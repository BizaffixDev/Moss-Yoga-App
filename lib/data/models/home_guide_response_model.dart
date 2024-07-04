class Item {
  int keyId;
  String name;
  String type;

  Item({required this.keyId, required this.name, required this.type});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      keyId: json['keyId'],
      name: json['name'],
      type: json['type'],
    );
  }
}

class HomeGuideResponseModel {
  List<Item> D;
  List<Item> O;
  List<Item> P;
  List<Item> S;
  List<Item> T;

  HomeGuideResponseModel({
    required this.D,
    required this.O,
    required this.P,
    required this.S,
    required this.T,
  });

  factory HomeGuideResponseModel.fromJson(Map<String, dynamic> json) {
    return HomeGuideResponseModel(
      D: (json['D'] as List).map((item) => Item.fromJson(item)).toList(),
      O: (json['O'] as List).map((item) => Item.fromJson(item)).toList(),
      P: (json['P'] as List).map((item) => Item.fromJson(item)).toList(),
      S: (json['S'] as List).map((item) => Item.fromJson(item)).toList(),
      T: (json['T'] as List).map((item) => Item.fromJson(item)).toList(),
    );
  }
}
