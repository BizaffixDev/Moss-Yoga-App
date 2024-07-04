import 'package:moss_yoga/presentation/providers/screen_state.dart';

abstract class MyClassesTeacherStates {}

class MyClassesTeacherInitialState extends MyClassesTeacherStates {}

class MyClassesTeacherLoadingState extends MyClassesTeacherStates {}
class MyClassesTeacherSuccessfulState extends MyClassesTeacherStates {
}

class MyClassesTeacherErrorState extends MyClassesTeacherStates {
  final ErrorType errorType;
  final String error;

  MyClassesTeacherErrorState({required this.error, required this.errorType});
}

class CancelBookingTeacherLoadingState extends MyClassesTeacherStates {}
class  CancelBookingTeacherSuccessfulState extends MyClassesTeacherStates {
}

class  CancelBookingTeacherErrorState extends MyClassesTeacherStates {
  final ErrorType errorType;
  final String error;

  CancelBookingTeacherErrorState({required this.error, required this.errorType});
}