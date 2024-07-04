import 'package:moss_yoga/presentation/providers/screen_state.dart';

abstract class StripeStates {}

class StripeInitialState extends StripeStates {}

class StripeLoadingState extends StripeStates {}

class StripeSuccessfulState extends StripeStates {
  final String paymentStatus;
  final String amount;

  StripeSuccessfulState({required this.paymentStatus, required this.amount});
}

class StripeErrorState extends StripeStates {
  final ErrorType errorType;
  final String error;

  StripeErrorState({required this.error, required this.errorType});
}
