import 'package:moss_yoga/presentation/providers/screen_state.dart';

abstract class TeacherHomeStates {}

class TeacherHomeInitialState extends TeacherHomeStates {}

class TeacherHomeLoadingState extends TeacherHomeStates {}

class TeacherHomeSuccessfulState extends TeacherHomeStates {}

class TeacherHomeNoOfSessionsSuccessfulState extends TeacherHomeStates {}

class TeacherHomeOnDemandButtonSuccessfulState extends TeacherHomeStates {}

class TeacherHomeOnDemandButtonOfflineSuccessfulState
    extends TeacherHomeStates {}

class TeacherHomeErrorState extends TeacherHomeStates {
  final ErrorType errorType;
  final String error;

  TeacherHomeErrorState({required this.error, required this.errorType});
}

class TeacherHomeOnDemandButtonErrorState extends TeacherHomeStates {
  final ErrorType errorType;
  final String error;

  TeacherHomeOnDemandButtonErrorState(
      {required this.error, required this.errorType});
}

class TeacherHomeNoOfSessionsErrorState extends TeacherHomeStates {
  final ErrorType errorType;
  final String error;

  TeacherHomeNoOfSessionsErrorState(
      {required this.error, required this.errorType});
}

class ScheduleDateTimeLoadingState extends TeacherHomeStates {}

class ScheduleDateTimeSuccessfulState extends TeacherHomeStates {}

class ScheduleDateTimeErrorState extends TeacherHomeStates {
  final ErrorType errorType;
  final String error;

  ScheduleDateTimeErrorState({required this.error, required this.errorType});
}
