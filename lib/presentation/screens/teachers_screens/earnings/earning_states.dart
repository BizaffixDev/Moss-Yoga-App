import 'package:moss_yoga/presentation/providers/screen_state.dart';

abstract class EarningsTeacherStates {}

class EarningsTeacherInitialState extends EarningsTeacherStates {}

class  EarningsTeacherLoadingState extends EarningsTeacherStates {}
class  EarningsTeacherSuccessfulState extends EarningsTeacherStates {
}

class  EarningsTeacherErrorState extends EarningsTeacherStates {
  final ErrorType errorType;
  final String error;

  EarningsTeacherErrorState({required this.error, required this.errorType});
}

