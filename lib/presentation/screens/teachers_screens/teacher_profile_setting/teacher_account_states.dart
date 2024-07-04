import 'package:moss_yoga/presentation/providers/screen_state.dart';

abstract class TeacherAccountStates {}

class TeacherAccountInitialState extends TeacherAccountStates {}

class TeacherChangePasswordLoadingState extends TeacherAccountStates {}
class TeacherChangePasswordSuccessfulState extends TeacherAccountStates {
}

class TeacherChangePasswordErrorState extends TeacherAccountStates {
  final ErrorType errorType;
  final String error;

  TeacherChangePasswordErrorState({required this.error, required this.errorType});
}

class TeacherDeleteAccountLoadingState extends TeacherAccountStates {}
class TeacherDeleteAccountSuccessfulState extends TeacherAccountStates {
}

class TeacherDeleteAccountErrorState extends TeacherAccountStates {
  final ErrorType errorType;
  final String error;

  TeacherDeleteAccountErrorState({required this.error, required this.errorType});
}

class TeacherProfileDetailsLoadingState extends TeacherAccountStates {}
class TeacherProfileDetailsSuccessfulState extends TeacherAccountStates {
}

class TeacherProfileDetailsErrorState extends TeacherAccountStates {
  final ErrorType errorType;
  final String error;

  TeacherProfileDetailsErrorState({required this.error, required this.errorType});
}


class UpdateTeacherProfileDetailsLoadingState extends TeacherAccountStates {}
class UpdateTeacherProfileDetailsSuccessfulState extends TeacherAccountStates {
}

class UpdateTeacherProfileDetailsErrorState extends TeacherAccountStates {
  final ErrorType errorType;
  final String error;

  UpdateTeacherProfileDetailsErrorState({required this.error, required this.errorType});
}



