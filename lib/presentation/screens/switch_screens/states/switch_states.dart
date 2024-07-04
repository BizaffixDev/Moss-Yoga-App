import 'package:moss_yoga/presentation/providers/screen_state.dart';

abstract class SwitchScreenStates {}

class SwitchScreenInitialState extends SwitchScreenStates {}

class SwitchScreenLoadingState extends SwitchScreenStates {}

class SwitchScreenSuccessfulSendToStudentState extends SwitchScreenStates {}

class SwitchScreenSuccessfulSendToTeacherState extends SwitchScreenStates {}

class SwitchScreenErrorGoBackStudentState extends SwitchScreenStates {
  final ErrorType errorType;
  final String error;

  SwitchScreenErrorGoBackStudentState(
      {required this.error, required this.errorType});
}

class SwitchScreenErrorGoBackTeacherState extends SwitchScreenStates {
  final ErrorType errorType;
  final String error;

  SwitchScreenErrorGoBackTeacherState(
      {required this.error, required this.errorType});
}
