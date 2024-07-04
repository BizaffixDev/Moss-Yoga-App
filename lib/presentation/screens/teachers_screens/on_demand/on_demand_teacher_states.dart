import 'package:moss_yoga/presentation/providers/screen_state.dart';

abstract class OnDemandTeacherStates {}

// --------------------------------------------------------------//

class OnDemandTeacherInitialState extends OnDemandTeacherStates {}

class OnDemandTeacherLoadingState extends OnDemandTeacherStates {}

class OnDemandTeacherSuccessfulState extends OnDemandTeacherStates {}

class OnDemandTeacherErrorState extends OnDemandTeacherStates {
  final ErrorType errorType;
  final String error;

  OnDemandTeacherErrorState({required this.error, required this.errorType});
}


class OnDemandTeacherAcceptLoadingState extends OnDemandTeacherStates {}

class OnDemandTeacherAcceptSuccessfulState extends OnDemandTeacherStates {}

class OnDemandTeacherAcceptErrorState extends OnDemandTeacherStates {
  final ErrorType errorType;
  final String error;

  OnDemandTeacherAcceptErrorState({required this.error, required this.errorType});
}


class OnDemandTeacherRejectLoadingState extends OnDemandTeacherStates {}

class OnDemandTeacherRejectSuccessfulState extends OnDemandTeacherStates {}

class OnDemandTeacherRejectErrorState extends OnDemandTeacherStates {
  final ErrorType errorType;
  final String error;

  OnDemandTeacherRejectErrorState({required this.error, required this.errorType});
}




