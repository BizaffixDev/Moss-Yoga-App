import 'dart:convert';


/*
import 'dart:convert';

GuideResponse guideResponseFromJson(String str) => GuideResponse.fromJson(json.decode(str));



class GuideResponse {
  List<KeyGuide> A;
  List<KeyGuide> B;
  List<KeyGuide> C;
  List<KeyGuide> D;
  List<KeyGuide> E;
  List<KeyGuide> F;
  List<KeyGuide> G;
  List<KeyGuide> H;
  List<KeyGuide> I;
  List<KeyGuide> J;
  List<KeyGuide> K;
  List<KeyGuide> L;
  List<KeyGuide> M;
  List<KeyGuide> N;
  List<KeyGuide> O;
  List<KeyGuide> P;
  List<KeyGuide> Q;
  List<KeyGuide> R;
  List<KeyGuide> S;
  List<KeyGuide> T;
  List<KeyGuide> U;
  List<KeyGuide> V;
  List<KeyGuide> W;
  List<KeyGuide> X;
  List<KeyGuide> Y;
  List<KeyGuide> Z;

  GuideResponse({
    required this.A,
    required this.B,
    required this.C,
    required this.D,
    required this.E,
    required this.F,
    required this.G,
    required this.H,
    required this.I,
    required this.J,
    required this.K,
    required this.L,
    required this.M,
    required this.N,
    required this.O,
    required this.P,
    required this.Q,
    required this.R,
    required this.S,
    required this.T,
    required this.U,
    required this.V,
    required this.W,
    required this.X,
    required this.Y,
    required this.Z,
  });

  factory GuideResponse.fromJson(Map<String, dynamic> json) {
    return GuideResponse(
      A: (json['A'] as List<dynamic>?)?.map((e) => KeyGuide.fromJson(e)).toList() ?? [],
      B: (json['B'] as List<dynamic>?)?.map((e) => KeyGuide.fromJson(e)).toList() ?? [],
      C: (json['C'] as List<dynamic>?)?.map((e) => KeyGuide.fromJson(e)).toList() ?? [],
      D: (json['D'] as List<dynamic>?)?.map((e) => KeyGuide.fromJson(e)).toList() ?? [],
      E: (json['E'] as List<dynamic>?)?.map((e) => KeyGuide.fromJson(e)).toList() ?? [],
      F: (json['F'] as List<dynamic>?)?.map((e) => KeyGuide.fromJson(e)).toList() ?? [],
      G: (json['G'] as List<dynamic>?)?.map((e) => KeyGuide.fromJson(e)).toList() ?? [],
      H: (json['H'] as List<dynamic>?)?.map((e) => KeyGuide.fromJson(e)).toList() ?? [],
      I: (json['I'] as List<dynamic>?)?.map((e) => KeyGuide.fromJson(e)).toList() ?? [],
      J: (json['J'] as List<dynamic>?)?.map((e) => KeyGuide.fromJson(e)).toList() ?? [],
      K: (json['K'] as List<dynamic>?)?.map((e) => KeyGuide.fromJson(e)).toList() ?? [],
      L: (json['L'] as List<dynamic>?)?.map((e) => KeyGuide.fromJson(e)).toList() ?? [],
      M: (json['M'] as List<dynamic>?)?.map((e) => KeyGuide.fromJson(e)).toList() ?? [],
      N: (json['N'] as List<dynamic>?)?.map((e) => KeyGuide.fromJson(e)).toList() ?? [],
      O: (json['O'] as List<dynamic>?)?.map((e) => KeyGuide.fromJson(e)).toList() ?? [],
      P: (json['P'] as List<dynamic>?)?.map((e) => KeyGuide.fromJson(e)).toList() ?? [],
      Q: (json['Q'] as List<dynamic>?)?.map((e) => KeyGuide.fromJson(e)).toList() ?? [],
      R: (json['R'] as List<dynamic>?)?.map((e) => KeyGuide.fromJson(e)).toList() ?? [],
      S: (json['S'] as List<dynamic>?)?.map((e) => KeyGuide.fromJson(e)).toList() ?? [],
      T: (json['T'] as List<dynamic>?)?.map((e) => KeyGuide.fromJson(e)).toList() ?? [],
      U: (json['U'] as List<dynamic>?)?.map((e) => KeyGuide.fromJson(e)).toList() ?? [],
      V: (json['V'] as List<dynamic>?)?.map((e) => KeyGuide.fromJson(e)).toList() ?? [],
      W: (json['W'] as List<dynamic>?)?.map((e) => KeyGuide.fromJson(e)).toList() ?? [],
      X: (json['X'] as List<dynamic>?)?.map((e) => KeyGuide.fromJson(e)).toList() ?? [],
      Y: (json['Y'] as List<dynamic>?)?.map((e) => KeyGuide.fromJson(e)).toList() ?? [],
      Z: (json['Z'] as List<dynamic>?)?.map((e) => KeyGuide.fromJson(e)).toList() ?? [],
    );
  }
}

class KeyGuide {
  int keyId;
  String name;
  String type;

  KeyGuide({
    required this.keyId,
    required this.name,
    required this.type,
  });

  factory KeyGuide.fromJson(Map<String, dynamic> json) {
    return KeyGuide(
      keyId: json['keyId'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
    );
  }
}
*/


class GuideResponse {
  final Map<String, List<KeyGuide>> guideMap;

  GuideResponse({required this.guideMap});

  factory GuideResponse.fromJson(Map<String, dynamic> json) {
    final guideMap = json.map<String, List<KeyGuide>>(
          (key, value) => MapEntry(
        key,
        (value as List).map((item) => KeyGuide.fromJson(item)).toList(),
      ),
    );
    return GuideResponse(guideMap: guideMap);
  }
}

class KeyGuide {
  final int keyId;
  final String name;
  final String type;

  KeyGuide({
    required this.keyId,
    required this.name,
    required this.type,
  });

  factory KeyGuide.fromJson(Map<String, dynamic> json) {
    return KeyGuide(
      keyId: json['keyId'],
      name: json['name'],
      type: json['type'],
    );
  }
}


