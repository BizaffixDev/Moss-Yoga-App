import 'package:moss_yoga/presentation/providers/screen_state.dart';

abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class HomeLoadingState extends HomeStates {}
class HomeSuccessfulState extends HomeStates {
}

class HomeErrorState extends HomeStates {
  final ErrorType errorType;
  final String error;

  HomeErrorState({required this.error, required this.errorType});
}



/*class ScheduleDateTimeLoadingState extends HomeStates {}
class ScheduleDateTimeSuccessfulState extends HomeStates {}
class ScheduleDateTimeErrorState extends HomeStates {
  final ErrorType errorType;
  final String error;

  ScheduleDateTimeErrorState({required this.error, required this.errorType});
}*/


class TeacherSessionScheduleLoadingState extends HomeStates {}
class TeacherSessionScheduleSuccessfulState extends HomeStates {}
class TeacherSessionScheduleErrorState extends HomeStates {
  final ErrorType errorType;
  final String error;

  TeacherSessionScheduleErrorState({required this.error, required this.errorType});
}


class PreBookingSessionLoadingState extends HomeStates {}
class PreBookingSessionSuccessfulState extends HomeStates {}
class PreBookingSessionErrorState extends HomeStates {
  final ErrorType errorType;
  final String error;

  PreBookingSessionErrorState({required this.error, required this.errorType});
}


class GetStyleByIdLoadingState extends HomeStates {}
class GetStyleByIdSuccessfulState extends HomeStates {}
class GetStyleByIdErrorState extends HomeStates {
  final ErrorType errorType;
  final String error;

  GetStyleByIdErrorState({required this.error, required this.errorType});
}

class GetPoseByIdLoadingState extends HomeStates {}
class GetPoseByIdSuccessfulState extends HomeStates {}
class GetPoseByIdErrorState extends HomeStates {
  final ErrorType errorType;
  final String error;

  GetPoseByIdErrorState({required this.error, required this.errorType});
}





