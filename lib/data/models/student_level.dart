// class StudentLevel {
//   static const String beginner = "Beginner";
//   static const String advanced = "Advanced";
//   static const String intermediate = "Intermediate";
//
//   static List<String> getAllLevels() {
//     return [
//       beginner,
//       advanced,
//       intermediate,
//     ].toSet().toList()
//       ..sort();
//   }
// }
enum StudentLevel {
  Beginner,
  Advanced,
  Intermediate,
}

List<String> getAllLevels() {
  return StudentLevel.values
      .map((level) => level.toString().split('.').last)
      .toList()
    ..sort();
}
