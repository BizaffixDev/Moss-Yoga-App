enum  ProfileCompletion{
  Incomplete,
  Complete,
  Pending
}

class TeacherProfileStatus{
  final ProfileCompletion status;

  TeacherProfileStatus({required this.status});
}