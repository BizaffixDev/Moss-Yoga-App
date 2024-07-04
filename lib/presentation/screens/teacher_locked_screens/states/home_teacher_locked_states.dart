import 'package:moss_yoga/presentation/providers/screen_state.dart';

abstract class TeacherLockedHomeStates {}

class TeacherLockedHomeInitialState extends TeacherLockedHomeStates {}

class TeacherLockedHomeLoadingState extends TeacherLockedHomeStates {}

class TeacherLockedHomeSuccessfulState extends TeacherLockedHomeStates {}

class TeacherLockedHomeGuidesSuccessfulState extends TeacherLockedHomeStates {}

class TeacherLockedHomeErrorState extends TeacherLockedHomeStates {
  final ErrorType errorType;
  final String error;

  TeacherLockedHomeErrorState({required this.error, required this.errorType});
}
