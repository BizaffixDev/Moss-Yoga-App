
class DurationSessionModel{
  final String duration;
  final int? budget;


  DurationSessionModel({required this.duration,  this.budget});
}

List<DurationSessionModel> durationList =  [
  DurationSessionModel(duration: "30",budget: 120),
  DurationSessionModel(duration: "60",budget: 150),
  DurationSessionModel(duration: "90",budget: 180),
];


class DurationSessions {
  static const String first = "30 min";
  static const String second  = "60 min";
  static const String third = "90 min";


  static List<String> getAllDurations() {
    return [
      first,
      second,
      third,

    ];
  }
}

class DurationSessionDropDownModel {
  final String selectDuration;

  DurationSessionDropDownModel({required this.selectDuration});
}