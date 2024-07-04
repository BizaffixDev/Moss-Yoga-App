import 'package:moss_yoga/presentation/providers/screen_state.dart';

abstract class NotifictionStudentsStates {}

class NotifictionStudentInitialState extends NotifictionStudentsStates {}

class  NotifictionStudentLoadingState extends NotifictionStudentsStates {}
class  NotifictionStudentSuccessfulState extends NotifictionStudentsStates {
}

class  NotifictionStudentErrorState extends NotifictionStudentsStates {
  final ErrorType errorType;
  final String error;

  NotifictionStudentErrorState({required this.error, required this.errorType});
}





