enum UserType{
  Beginner,
  Intermediate,
  Advanced,
  None,
}

class UserLevel{
  final UserType userType;

  UserLevel({required this.userType});
}