import 'package:moss_yoga/presentation/providers/screen_state.dart';

abstract class HelpSupportStates {}

class HelpSupportStatesInitialState extends HelpSupportStates {}

class LearnMossYogaLoadingState extends HelpSupportStates {}
class LearnMossYogaSuccessfulState extends HelpSupportStates {
}

class LearnMossYogaErrorState extends HelpSupportStates {
  final ErrorType errorType;
  final String error;

  LearnMossYogaErrorState({required this.error, required this.errorType});
}


class FaqLoadingState extends HelpSupportStates {}
class FaqSuccessfulState extends HelpSupportStates {
}

class FaqErrorState extends HelpSupportStates {
  final ErrorType errorType;
  final String error;

  FaqErrorState({required this.error, required this.errorType});
}


class FeedbackLoadingState extends HelpSupportStates {}
class  FeedbackSuccessfulState extends HelpSupportStates {
}

class  FeedbackErrorState extends HelpSupportStates {
  final ErrorType errorType;
  final String error;

  FeedbackErrorState({required this.error, required this.errorType});
}

