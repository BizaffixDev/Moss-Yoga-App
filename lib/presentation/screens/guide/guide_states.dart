

import '../../providers/screen_state.dart';

abstract class GuideStates {}

class GuideInitialState extends GuideStates {}


class GuideLoadingState extends GuideStates {}
class GuideSuccessfulState extends GuideStates {
}

class GuideErrorState extends GuideStates {
  final ErrorType errorType;
  final String error;

  GuideErrorState({required this.error, required this.errorType});
}


class GuidePoseLoadingState extends GuideStates {}
class GuidePoseSuccessfulState extends GuideStates {
}

class GuidePoseErrorState extends GuideStates {
  final ErrorType errorType;
  final String error;

  GuidePoseErrorState({required this.error, required this.errorType});
}


class GuideStyleLoadingState extends GuideStates {}
class GuideStyleSuccessfulState extends GuideStates {
}

class GuideStyleErrorState extends GuideStates {
  final ErrorType errorType;
  final String error;

  GuideStyleErrorState({required this.error, required this.errorType});
}

class GuideDetailAZLoadingState extends GuideStates {}
class GuideDetailAZSuccessfulState extends GuideStates {
}

class GuideDetailAZErrorState extends GuideStates {
  final ErrorType errorType;
  final String error;

  GuideDetailAZErrorState({required this.error, required this.errorType});
}

