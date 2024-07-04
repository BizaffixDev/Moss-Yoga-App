// // enum UserGender { Male, Female, NonBinary, PreferNotToSay }
// enum UserGender { Male, Female, Non Binary, Prefer Not To Say }
//
// class UserGenderModel {
//   final UserGender userGender;
//
//   UserGenderModel({required this.userGender});
// }
class UserGender {
  static const String male = "Male";
  static const String female = "Female";
  static const String preferNotToSay = "Prefer Not To Say";

  static List<String> getAllGenders() {
    return [
      male,
      female,
      preferNotToSay,
    ];
  }
}

