import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/data_sources/user_local_data_source.dart';
import '../../../data/models/login_response_model.dart';
import '../../../data/models/notification_response_model.dart';
import '../../../data/network/error_handler_interceptor.dart';
import '../../../data/repositories/teacher_repositories/motification_teacher_repository.dart';
import '../../screens/teachers_screens/notifications/notification_teacher_states.dart';
import '../screen_state.dart';
import '../teachers_providers/home_teacher_provider.dart';


final notificationTeacherNotifierProvider =
StateNotifierProvider<NotificationTeacherNotifierNotifier, NotifictionTeachersStates>(
      (ref) =>
      NotificationTeacherNotifierNotifier(
        ref: ref,
        notificationTeacherRepository: GetIt.I<NotificationTeacherRepository>(),
        userLocalDataSource: GetIt.I<UserLocalDataSource>(),
      ),
);

class NotificationTeacherNotifierNotifier extends StateNotifier<NotifictionTeachersStates> {
  NotificationTeacherNotifierNotifier({
    required this.ref,
    required this.notificationTeacherRepository,
    required this.userLocalDataSource,
  }) : super(NotifictionTeacherInitialState());

  final Ref ref;
  final NotificationTeacherRepository notificationTeacherRepository;
  final UserLocalDataSource userLocalDataSource;

  final teacherObjectProvider = StateProvider<LoginResponseModel>((ref) =>
      LoginResponseModel(
          userId: -1,
          email: '',
          username: '',
          token: '-1',
          userType: 'userType',
          message: 'message',
          isVerified: false));

  Future getTeacherData() async {
    LoginResponseModel? user = await userLocalDataSource.getUser();
    print(user?.userType.toString());
    print(user?.email.toString());
    print(user?.userId.toString());
    print(user?.username.toString());
    ref.read(teacherObjectProvider.notifier).state = user!;

    ref.read(nameProvider.notifier).state = user.username;
    ref.read(teacherIdProvider.notifier).state = user.userId;
    ref.read(emailProvider.notifier).state = user.email;


    print("TEACHER ID =========== ${ref.read(teacherIdProvider.notifier).state}");
  }



  Future getNotifications() async{



    print("STUDENT IDDD ===== ${ref.read(teacherIdProvider)}");


    try {
      state = NotifictionTeacherLoadingState();
      final response = await notificationTeacherRepository.getNotifications(userId: ref.read(teacherIdProvider));
      state = NotifictionTeacherSuccessfulState();


      print("TODAY List Data  ${response.response.today}");


      final todayNotifier = ref.read(todayProvider.notifier);
      final yesteradyNotifier = ref.read(yesteradyProvider.notifier);
      final olderNotifier = ref.read(olderProvider.notifier);

      ref.read(notificationCount.notifier).state = response.count;
      todayNotifier.deleteAllToday();
      yesteradyNotifier.deleteAllYesterday();
      olderNotifier.deleteAllOlder();
      todayNotifier.updateToday(response.response.today);
      yesteradyNotifier.updateYesterday(response.response.yesterday);
      olderNotifier.updateOlder(response.response.older);

      print("TODAY =========     $todayNotifier");
      print("YESTERDAY =========     $yesteradyNotifier");
      print("OLDER =========     $olderNotifier");





      return response;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state =  NotifictionTeacherErrorState(error: e.message, errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = NotifictionTeacherErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = NotifictionTeacherErrorState(error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = NotifictionTeacherErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = NotifictionTeacherErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = NotifictionTeacherErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = NotifictionTeacherErrorState(error: e.toString(), errorType: ErrorType.other);
    }

  }




}


class TodayListsNotifier extends StateNotifier<List<NotificationData>> {
  TodayListsNotifier() : super([]);

  updateToday(List<NotificationData> today) {
    state = today;
  }

  deleteAllToday() {
    state = []; // Set the state to an empty list to delete all teachers
  }

  // Cancel any active subscriptions or event listeners here
  @override
  void dispose() {
    // Dispose any resources (e.g., cancel streams, subscriptions, etc.)
    // This is important to prevent using the notifier after it's been disposed.
    super.dispose();
  }

}

final todayProvider = StateNotifierProvider<TodayListsNotifier, List<NotificationData>>(
      (ref) => TodayListsNotifier(),
);


class YesterdayListsNotifier extends StateNotifier<List<NotificationData>> {
  YesterdayListsNotifier() : super([]);

  updateYesterday(List<NotificationData> yesterday) {
    state = yesterday;
  }

  deleteAllYesterday() {
    state = []; // Set the state to an empty list to delete all teachers
  }

  // Cancel any active subscriptions or event listeners here
  @override
  void dispose() {
    // Dispose any resources (e.g., cancel streams, subscriptions, etc.)
    // This is important to prevent using the notifier after it's been disposed.
    super.dispose();
  }

}

final yesteradyProvider = StateNotifierProvider<YesterdayListsNotifier, List<NotificationData>>(
      (ref) => YesterdayListsNotifier(),
);


class OlderListsNotifier extends StateNotifier<List<NotificationData>> {
  OlderListsNotifier() : super([]);

  updateOlder(List<NotificationData> older) {
    state = older;
  }

  deleteAllOlder() {
    state = []; // Set the state to an empty list to delete all teachers
  }

  // Cancel any active subscriptions or event listeners here
  @override
  void dispose() {
    // Dispose any resources (e.g., cancel streams, subscriptions, etc.)
    // This is important to prevent using the notifier after it's been disposed.
    super.dispose();
  }

}

final olderProvider = StateNotifierProvider<OlderListsNotifier, List<NotificationData>>(
      (ref) => OlderListsNotifier(),
);


final notificationCount = StateProvider<int>((ref) {
  return 0;
});
