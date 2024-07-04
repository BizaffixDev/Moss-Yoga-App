import 'package:moss_yoga/presentation/providers/screen_state.dart';

abstract class MyTeachersStates {}

class MyTeacherstInitialState extends MyTeachersStates {}

class MyTeachersLoadingState extends MyTeachersStates {}
class MyTeachersSuccessfulState extends MyTeachersStates {
}

class MyTeachersErrorState extends MyTeachersStates {
  final ErrorType errorType;
  final String error;

  MyTeachersErrorState({required this.error, required this.errorType});
}


















