import 'package:moss_yoga/presentation/providers/screen_state.dart';

abstract class MyCustomFirebaseMessagingStates {}

class MyCustomFirebaseMessagingInitialState
    extends MyCustomFirebaseMessagingStates {}

class MyCustomFirebaseMessagingLoadingState
    extends MyCustomFirebaseMessagingStates {}

class MyCustomFirebaseMessagingSuccessfulState
    extends MyCustomFirebaseMessagingStates {}

class MyCustomFirebaseMessagingErrorState
    extends MyCustomFirebaseMessagingStates {
  final ErrorType errorType;
  final String error;

  MyCustomFirebaseMessagingErrorState(
      {required this.error, required this.errorType});
}
