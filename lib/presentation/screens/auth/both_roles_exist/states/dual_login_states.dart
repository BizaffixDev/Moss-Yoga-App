import 'package:moss_yoga/presentation/providers/screen_state.dart';

abstract class DualLoginStates {}

class DualLoginInitialState extends DualLoginStates {}

class DualLoginLoadingState extends DualLoginStates {}

class DualLoginSuccessfulStateStudent extends DualLoginStates {}

class DualLoginSuccessfulStateTeacher extends DualLoginStates {
  DualLoginSuccessfulStateTeacher({required this.isVerified});

  bool isVerified;
}

class DualLoginSuccessfulStateTeacherNotVerified extends DualLoginStates {}

class DualLoginErrorState extends DualLoginStates {
  final ErrorType errorType;
  final String error;

  DualLoginErrorState({required this.error, required this.errorType});
}
