

import 'package:moss_yoga/presentation/providers/screen_state.dart';

abstract class NotificationStates {}

class Initial extends NotificationStates {}

class Loading extends NotificationStates {}

class NotificationErrorState extends NotificationStates {
  NotificationErrorState({required this.error, required this.errorType});
  final String error;
  final ErrorType errorType;
}

class NotificationsFetched extends NotificationStates {
  NotificationsFetched(
      {required this.NotificationsListLastWeek,
      required this.NotificationsList});
  final  NotificationsList;
  final  NotificationsListLastWeek;
}

class NavigateTo extends NotificationStates {
  NavigateTo(
      {required this.pagePath, required this.navigationType, this.params});
  final String pagePath;
  final String navigationType;
  final dynamic params;
}
