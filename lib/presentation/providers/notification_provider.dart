import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/notifications/states/notification_states.dart';

class NotificationNotifier extends StateNotifier<NotificationStates> {
  NotificationNotifier({
    // required this.notificationRepository,
    required this.ref,
  }) : super(Initial());

  final Ref ref;
  // final NotificationRepository notificationRepository;
  }
  // void convertLocalToKSI() async {

  // }

  // Last Week => 7Days? Notification All

  // Future<void> getUserNotifications(BuildContext context) async {
  //   state = Loading();
  //   try {
  //     final pakistanTime = DateTime.now(); //Emulator time is Pakistan time
  //     // var pakistanTime_1w = pakistanTime.subtract(const Duration(days: 7));
  //     final ksiTimeNow =
  //     TZDateTime.from(pakistanTime, getLocation('Asia/Riyadh'));
  //     // final ksiTime_1w = new TZDateTime.from(pakistanTime_1w, getLocation('Asia/Riyadh'));
  //     print('Local Pakistan Time Now: $pakistanTime');
  //     print('KSI Time: $ksiTimeNow');
  //     // print('Local Pakistan Time Last Week: ' + pakistanTime_1w.toString());
  //     // print('KSI Time Last Week: ' + ksiTimeNow.toString());
  //     // print('KSI Time Last Week: ' + ksiTime_1w.toString());
  //
  //     // var now = new DateTime.now();
  //     // var now_1w = now.subtract(const Duration(days: 7));
  //
  //     final response = await notificationRepository.getUserNotifications();
  //
  //     final TodayInvestmentList =
  //     response.data.investment.where((notification) {
  //       final date = notification.notificationDate;
  //       // debugPrint('Nows Day:' +now.day.toString()+ 'Notification Day:' + date.day.toString());
  //       return ksiTimeNow.day == date.day;
  //     }).toList();
  //
  //     final TodayGeneralList = response.data.general.where((notification) {
  //       final date = notification.notificationDate;
  //       // debugPrint('Nows Day:' +now.day.toString()+ 'Notification Day:' + date.day.toString());
  //       return ksiTimeNow.year == date.year &&
  //           ksiTimeNow.month == date.month &&
  //           ksiTimeNow.day == date.day;
  //     }).toList();
  //
  //     final LastWeekInvestmentList =
  //     response.data.investment.where((notification) {
  //       final date = notification.notificationDate;
  //       debugPrint('All days before today are ${ksiTimeNow.day != date.day}');
  //       // return ksiTimeNow.year != date.year && ksiTimeNow.month != date.month && ksiTimeNow.day != date.day ;
  //       return ksiTimeNow.day != date.day;
  //     }).toList();
  //
  //     // final LastWeekUserList2 = response.data.user.where((notification) {
  //     //   final date = notification.notificationDate;
  //     //   print('All days before today are ${ksiTimeNow.day != date.day}');
  //     //   return ksiTime_1w.isBefore(date);
  //     // }).toList();
  //
  //     final LastWeeksGeneralList = response.data.general.where((notification) {
  //       final date = notification.notificationDate;
  //       // debugPrint('LastWeek Day:' +now_1w.day.toString()+ 'LastWeek Notification Day:' + date.toString());
  //       // return ksiTimeNow.year != date.year && ksiTimeNow.month != date.month && ksiTimeNow.day != date.day ;
  //       debugPrint('All days before today are ${ksiTimeNow.day != date.day}');
  //       return ksiTimeNow.day != date.day;
  //     }).toList();
  //
  //     ref
  //         .read(notificationResponseListLastWeekProvider.notifier)
  //         .state
  //         .investment = LastWeekInvestmentList;
  //     ref
  //         .read(notificationResponseListLastWeekProvider.notifier)
  //         .state
  //         .general = LastWeeksGeneralList;
  //
  //     ref
  //         .read(notificationResponseListTodayProvider.notifier)
  //         .state
  //         .investment = TodayInvestmentList;
  //     ref.read(notificationResponseListTodayProvider.notifier).state.general =
  //         TodayGeneralList;
  //
  //     await Future.delayed(Duration(microseconds: 5), () {
  //       state = NotificationsFetched(
  //         NotificationsList:
  //         ref.read(notificationResponseListTodayProvider.notifier).state,
  //         NotificationsListLastWeek:
  //         ref.read(notificationResponseListLastWeekProvider.notifier).state,
  //       );
  //     });
  //
  //     // final checkUserReads = response.data.user.firstWhere((notification) =>notification.notificationStatus == false);
  //     // if(checkUserReads.notificationStatus == false){
  //     //   debugPrint('check is false? => ${checkUserReads.notificationStatus}');
  //     //   ref
  //     //       .read(notificationResponseUserCheckStatus
  //     //       .notifier)
  //     //       .state  = checkUserReads.notificationStatus;
  //     // }
  //     // else{
  //     //   debugPrint('check is true? => ${checkUserReads.notificationStatus}');
  //     //   ref
  //     //       .read(notificationResponseUserCheckStatus
  //     //       .notifier)
  //     //       .state  = checkUserReads.notificationStatus;
  //     // }
  //     // final checkGeneralReads = response.data.general.firstWhere((notification) =>notification.notificationStatus == false);
  //     // if(checkGeneralReads.notificationStatus == false){
  //     //   debugPrint('check is false? => ${checkGeneralReads.notificationStatus}');
  //     //   ref
  //     //       .read(notificationResponseGeneralCheckStatus
  //     //       .notifier)
  //     //       .state  = checkGeneralReads.notificationStatus;
  //     // }
  //     // else{
  //     //   debugPrint('check is true? => ${checkGeneralReads.notificationStatus}');
  //     //   ref
  //     //       .read(notificationResponseGeneralCheckStatus
  //     //       .notifier)
  //     //       .state  = checkGeneralReads.notificationStatus;
  //     // }
  //   } on UnauthorizedException catch (e) {
  //     state = NotificationErrorState(
  //         error: e.toString(), errorType: ErrorType.unauthorized);
  //   } on BackendResponseError catch (e) {
  //     state = NotificationErrorState(
  //         error: e.toString(), errorType: ErrorType.other);
  //   } on NoInternetConnectionException catch (_) {
  //     state = NotificationErrorState(
  //         error: _.toString(), errorType: ErrorType.other);
  //   }
  //   // on DioError catch (e) {
  //   //   state = NotificationErrorState(
  //   //       error: Strings.commonError, errorType: ErrorType.other);
  //   // }
  //   on DioError catch (e) {
  //     state = NotificationErrorState(
  //         error: e.requestOptions.data.toString(), errorType: ErrorType.other);
  //   }
  // }

//   Future<void> setReadNotifications(BuildContext context,
//       NotificationReadRequest notificationReadRequest) async {
//     // state = Loading();
//     try {
//       final response = await notificationRepository.readNotification(
//           notificationReadRequest: notificationReadRequest);
//       ref.read(notificationReadResponseProvider.notifier).state = response.data;
//       // final profile = ref.watch(userProfileProvider);
//       // final notifications = profile.total_unread_notifications;
//       ref.read(userProfileProvider.state).state.total_unread_notifications = 0;
//       debugPrint(
//           'Notification total_unread_notifications is changed to ${ref.watch(userProfileProvider.notifier).state.total_unread_notifications}');
//       await Future.delayed(Duration.zero, () {});
//       //
//       // final response2 = await notificationRepository.getUserNotifications();
//       // ref
//       //     .read(notificationResponseListProvider.notifier)
//       //     .state = response2.data;
//       //
//       // state = NotificationsFetched(
//       //   NotificationsList: ref.read(notificationResponseListProvider),);
//     } on UnauthorizedException catch (e) {
//       state = NotificationErrorState(
//           error: e.toString(), errorType: ErrorType.unauthorized);
//     }
//     on NoInternetConnectionException catch (_) {
//       state = NotificationErrorState(
//           error: _.toString(), errorType: ErrorType.other);
//     }
//     on BackendResponseError catch (e) {
//       state = NotificationErrorState(
//           error: e.toString(), errorType: ErrorType.other);
//     }
//     on DioError catch (e) {
//       state = NotificationErrorState(
//           error: e.requestOptions.data.toString(), errorType: ErrorType.other);
//     }
//   }
// }
//
// final notificationReadResponseProvider =
// StateProvider<NotificationReadResponse>((_) {
//   return NotificationReadResponse();
// });
//
// final notificationResponseListTodayProvider =
// StateProvider<NotificationResponseModel>((_) {
//   return NotificationResponseModel(investment: [], general: []);
// });
// final notificationResponseListLastWeekProvider =
// StateProvider<NotificationResponseModel>((_) {
//   return NotificationResponseModel(investment: [], general: []);
// });
// final notificationForceChangeTab1Provider = StateProvider<bool>((_) => false);
// final notificationForceChangeTab2Provider = StateProvider<bool>((_) => false);
//
// final notificationResponseProvider =
// StateNotifierProvider<NotificationNotifier, NotificationStates>((ref) {
//   return NotificationNotifier(
//     ref: ref,
//     notificationRepository: GetIt.I<NotificationRepository>(),
//   );
// });
