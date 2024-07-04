import '../../../providers/screen_state.dart';

abstract class NotifictionTeachersStates {}

class NotifictionTeacherInitialState extends  NotifictionTeachersStates{}


class  NotifictionTeacherLoadingState extends NotifictionTeachersStates {}
class  NotifictionTeacherSuccessfulState extends NotifictionTeachersStates {
}

class  NotifictionTeacherErrorState extends NotifictionTeachersStates {
  final ErrorType errorType;
  final String error;

  NotifictionTeacherErrorState({required this.error, required this.errorType});
}
