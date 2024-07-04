class StudentConditions{
  final String title;
  bool value;



  StudentConditions({
    required this.title,
    this.value = false,
  });


}



final chronicConditionsList = [
  StudentConditions(title: "Mental Disorder"),
  StudentConditions(title: "Blood Pressure"),
  StudentConditions(title: "Asthma"),
  StudentConditions(title: "Others"),
];

final physicalConditionsList = [
  StudentConditions(title: "Hips"),
  StudentConditions(title: "Shoulder"),
  StudentConditions(title: "Ankle"),
  StudentConditions(title: "Others"),
];