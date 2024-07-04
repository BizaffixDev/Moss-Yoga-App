enum UserIntention{
  Physical,
  Spiritual,
  Mental,
  None
}

class UserIntentionModel{
  final UserIntention userIntention;

  UserIntentionModel({required this.userIntention});
}