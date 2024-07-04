import 'package:moss_yoga/presentation/providers/screen_state.dart';

abstract class MyClassesStudentStates {}

class MyClassesStudentInitialState extends MyClassesStudentStates {}

class MyClassesStudentLoadingState extends MyClassesStudentStates {}
class MyClassesStudentSuccessfulState extends MyClassesStudentStates {
}

class MyClassesStudentErrorState extends MyClassesStudentStates {
  final ErrorType errorType;
  final String error;

  MyClassesStudentErrorState({required this.error, required this.errorType});
}

class CancelBookingStudentLoadingState extends MyClassesStudentStates {}
class  CancelBookingStudentSuccessfulState extends MyClassesStudentStates {
}

class  CancelBookingStudentErrorState extends MyClassesStudentStates {
  final ErrorType errorType;
  final String error;

  CancelBookingStudentErrorState({required this.error, required this.errorType});
}


class RescheduleBookingStudentLoadingState extends MyClassesStudentStates {}
class  RescheduleBookingStudentSuccessfulState extends MyClassesStudentStates {
}

class RescheduleBookingStudentErrorState extends MyClassesStudentStates {
  final ErrorType errorType;
  final String error;

  RescheduleBookingStudentErrorState({required this.error, required this.errorType});
}


class RescheduleTeacherDetailsLoadingState extends MyClassesStudentStates {}
class  RescheduleTeacherDetailsSuccessfulState extends MyClassesStudentStates {
}

class RescheduleTeacherDetailsErrorState extends MyClassesStudentStates {
  final ErrorType errorType;
  final String error;

  RescheduleTeacherDetailsErrorState({required this.error, required this.errorType});
}


