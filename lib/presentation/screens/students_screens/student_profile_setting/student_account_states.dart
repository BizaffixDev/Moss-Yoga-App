import 'package:moss_yoga/presentation/providers/screen_state.dart';

abstract class StudentAccountStates {}

class StudentAccountInitialState extends StudentAccountStates {}

class StudentChangePasswordLoadingState extends StudentAccountStates {}
class StudentChangePasswordSuccessfulState extends StudentAccountStates {
}

class StudentChangePasswordErrorState extends StudentAccountStates {
  final ErrorType errorType;
  final String error;

  StudentChangePasswordErrorState({required this.error, required this.errorType});
}

class StudentDeleteAccountLoadingState extends StudentAccountStates {}
class StudentDeleteAccountSuccessfulState extends StudentAccountStates {
}

class StudentDeleteAccountErrorState extends StudentAccountStates {
  final ErrorType errorType;
  final String error;

  StudentDeleteAccountErrorState({required this.error, required this.errorType});
}

class StudentProfileDetailsLoadingState extends StudentAccountStates {}
class StudentProfileDetailsSuccessfulState extends StudentAccountStates {
}

class StudentProfileDetailsErrorState extends StudentAccountStates {
  final ErrorType errorType;
  final String error;

  StudentProfileDetailsErrorState({required this.error, required this.errorType});
}


class UpdateStudentProfileDetailsLoadingState extends StudentAccountStates {}
class UpdateStudentProfileDetailsSuccessfulState extends StudentAccountStates {
}

class UpdateStudentProfileDetailsErrorState extends StudentAccountStates {
  final ErrorType errorType;
  final String error;

  UpdateStudentProfileDetailsErrorState({required this.error, required this.errorType});
}




