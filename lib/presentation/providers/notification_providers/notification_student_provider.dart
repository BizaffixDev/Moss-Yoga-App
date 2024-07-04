import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/data_sources/user_local_data_source.dart';
import 'package:moss_yoga/data/models/notification_response_model.dart';
import 'package:moss_yoga/data/repositories/notification_student_repository.dart';
import 'package:moss_yoga/presentation/screens/payment_methods/states/payment_states.dart';

import '../../../data/models/login_response_model.dart';
import '../../../data/models/my_classes_student_response_model.dart';
import '../../../data/network/error_handler_interceptor.dart';
import '../../screens/students_screens/notification_screen/notification_student_states.dart';
import '../home_provider.dart';
import '../screen_state.dart';


final notificationStudentNotifierProvider =
StateNotifierProvider<NotificationStudentNotifierNotifier, NotifictionStudentsStates>(
      (ref) =>
      NotificationStudentNotifierNotifier(
        ref: ref,
        notificationStudentRepository: GetIt.I<NotificationStudentRepository>(),
        userLocalDataSource: GetIt.I<UserLocalDataSource>(),
      ),
);

class NotificationStudentNotifierNotifier extends StateNotifier<NotifictionStudentsStates> {
  NotificationStudentNotifierNotifier({
    required this.ref,
    required this.notificationStudentRepository,
    required this.userLocalDataSource,
  }) : super(NotifictionStudentInitialState());

  final Ref ref;
  final NotificationStudentRepository notificationStudentRepository;
  final UserLocalDataSource userLocalDataSource;


  final studentObjectProvider = StateProvider<LoginResponseModel>((ref) =>
      LoginResponseModel(
          userId: -1,
          email: '',
          username: '',
          token: '-1',
          userType: 'userType',
          message: 'message',
          isVerified: false));

  Future getStudentData() async {
    LoginResponseModel? user = await userLocalDataSource.getUser();
    print(user?.userType.toString());
    print(user?.email.toString());
    print(user?.userId.toString());
    print(user?.username.toString());
    ref.read(studentObjectProvider.notifier).state = user!;

    ref.read(nameProvider.notifier).state = user.username;
    ref.read(studentIdProvider.notifier).state = user.userId;
    ref.read(emailProvider.notifier).state = user.email;
    ref.read(studentIdProvider.notifier).state = user.userId;

    print("USER ID =========== ${ref.read(studentIdProvider.notifier).state}");
  }



  Future getNotifications() async{



    print("STUDENT IDDD ===== ${ref.read(studentIdProvider)}");


    try {
      state = NotifictionStudentLoadingState();
      final response = await notificationStudentRepository.getNotifications(userId: ref.read(studentIdProvider));
      state = NotifictionStudentSuccessfulState();


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
      state = NotifictionStudentErrorState(error: e.message, errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = NotifictionStudentErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = NotifictionStudentErrorState(error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = NotifictionStudentErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = NotifictionStudentErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = NotifictionStudentErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = NotifictionStudentErrorState(error: e.toString(), errorType: ErrorType.other);
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
