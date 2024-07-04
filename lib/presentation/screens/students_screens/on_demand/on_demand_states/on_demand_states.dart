import 'package:moss_yoga/presentation/providers/screen_state.dart';

abstract class OnDemandStudentStates {}

// --------------------------------------------------------------//

class OnDemandStudentInitialState extends OnDemandStudentStates {}

class OnDemandStudentLoadingState extends OnDemandStudentStates {}

class OnDemandStudentSuccessfulState extends OnDemandStudentStates {}

class OnDemandStripeErrorState extends OnDemandStudentStates {
  final ErrorType errorType;
  final String error;

  OnDemandStripeErrorState({required this.error, required this.errorType});
}

// class OnDemandStripeLoadingState extends OnDemandStudentStates {}
class OnDemandStripeSuccessfulState extends OnDemandStudentStates {
  final String paymentStatus;
  final String amount;

  OnDemandStripeSuccessfulState(
      {required this.paymentStatus, required this.amount});
}

class OnDemandStudentTeacherAcceptedRequestState extends OnDemandStudentStates {
  final String price;

  OnDemandStudentTeacherAcceptedRequestState({required this.price});
}

class OnDemandStudentTeacherLoadingState extends OnDemandStudentStates {}

class OnDemandStudentErrorState extends OnDemandStudentStates {
  final ErrorType errorType;
  final String error;

  OnDemandStudentErrorState({required this.error, required this.errorType});
}

// --------------------------------------------------------------//

// class FilterStudentLoadingState extends OnDemandStudentStates {}

class FilterStudentSuccessfulState extends OnDemandStudentStates {}

class FilterStudentErrorState extends OnDemandStudentStates {
  final ErrorType errorType;
  final String error;

  FilterStudentErrorState({required this.error, required this.errorType});
}

class OnDemandStudentBookingLoadingState extends OnDemandStudentStates {}

class OnDemandStudentBookingSuccessfulState extends OnDemandStudentStates {}

class OnDemandStudentBookingErrorState extends OnDemandStudentStates {
  final ErrorType errorType;
  final String error;

  OnDemandStudentBookingErrorState(
      {required this.error, required this.errorType});
}

/*
class GuideStudentLoadingState extends OnDemandStudentStates {}
class GuideStudentSuccessfulState extends OnDemandStudentStates {
}

class GuideStudentErrorState extends OnDemandStudentStates {
  final ErrorType errorType;
  final String error;

  GuideStudentErrorState({required this.error, required this.errorType});
}
*/
