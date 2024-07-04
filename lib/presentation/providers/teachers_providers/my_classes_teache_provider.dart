import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/models/my_class_teacher_request_model.dart';
import 'package:moss_yoga/presentation/providers/screen_state.dart';
import 'package:moss_yoga/presentation/screens/teachers_screens/my_classes/my_classes_teacher_states.dart';

import '../../../data/data_sources/user_local_data_source.dart';
import '../../../data/models/login_response_model.dart';
import '../../../data/models/my_classes_teacher_response_model.dart';
import '../../../data/network/error_handler_interceptor.dart';
import '../../../data/repositories/teacher_repositories/my_classes_teacher_repository.dart';
import 'home_teacher_provider.dart';

final myClassesTeacherNotifierProvider =
    StateNotifierProvider<MyClassesTeacherNotifier, MyClassesTeacherStates>(
  (ref) => MyClassesTeacherNotifier(
    ref: ref,
    myClassesTeacherRepository: GetIt.I<MyClassesTeacherRepository>(),
    userLocalDataSource: GetIt.I<UserLocalDataSource>(),
  ),
);

class MyClassesTeacherNotifier extends StateNotifier<MyClassesTeacherStates> {
  MyClassesTeacherNotifier(
      {required this.ref,
      required this.myClassesTeacherRepository,
      required this.userLocalDataSource})
      : super(MyClassesTeacherInitialState());

  final Ref ref;
  final MyClassesTeacherRepository myClassesTeacherRepository;
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

    print(
        "TEACHER ID =========== ${ref.read(teacherIdProvider.notifier).state}");
  }

  Future getMyClassesData({required String date}) async {
    print('teacher id ${ref.read(teacherIdProvider).toString()}');
    MyClassTeacherRequest data = MyClassTeacherRequest(
      teacherId: ref.read(teacherIdProvider).toString(),
      date: date,
    );

    try {
      state = MyClassesTeacherLoadingState();
      final response = await myClassesTeacherRepository.myClassesData(
          myClassTeacherRequest: data);
      state = MyClassesTeacherSuccessfulState();
      print("UPCOMING List Data Provider ${response.upcoming}");
      final upComingClassesNotifier =
          ref.read(upcomingClassesProvider.notifier);
      final completedClassesNotifier =
          ref.read(completedClassesProvider.notifier);
      final cancelledClassesNotifier =
          ref.read(cancelledClassesProvider.notifier);
      upComingClassesNotifier.deleteAllUpcoming();
      completedClassesNotifier.deleteAllCompleted();
      cancelledClassesNotifier.deleteAllCancelled();
      upComingClassesNotifier.updateUpcoming(response.upcoming);
      completedClassesNotifier.updateCompleted(response.confirmed);
      cancelledClassesNotifier.updateCancelled(response.cancelled);

      print("UPCOMING CLASSES =========     $upComingClassesNotifier");
      print("COMPLETED CLASSES =========     $completedClassesNotifier");
      print("CANCELLED CLASSES =========     $cancelledClassesNotifier");
      return response;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = MyClassesTeacherErrorState(
          error: e.message, errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = MyClassesTeacherErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = MyClassesTeacherErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = MyClassesTeacherErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = MyClassesTeacherErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = MyClassesTeacherErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = MyClassesTeacherErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  //FOR CANCELLING BOOKINGS
  Future cancelBooking({required String bookingCode}) async {
    try {
      state = CancelBookingTeacherLoadingState();
      final response = await myClassesTeacherRepository.cancelBooking(
          bookingCode: bookingCode);
      state = CancelBookingTeacherSuccessfulState();

      final upComingClassesNotifier =
          ref.read(upcomingClassesProvider.notifier);
      final completedClassesNotifier =
          ref.read(completedClassesProvider.notifier);
      final cancelledClassesNotifier =
          ref.read(cancelledClassesProvider.notifier);
      upComingClassesNotifier.deleteAllUpcoming();
      completedClassesNotifier.deleteAllCompleted();
      cancelledClassesNotifier.deleteAllCancelled();
      upComingClassesNotifier.updateUpcoming(ref.read(upcomingClassesProvider));
      completedClassesNotifier
          .updateCompleted(ref.read(completedClassesProvider));
      cancelledClassesNotifier
          .updateCancelled(ref.read(cancelledClassesProvider));

      return response;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = CancelBookingTeacherErrorState(
          error: e.message, errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = CancelBookingTeacherErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = CancelBookingTeacherErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = CancelBookingTeacherErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = CancelBookingTeacherErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = CancelBookingTeacherErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = CancelBookingTeacherErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }
}

/*
final upcomingClassesProvider = StateProvider<List<ClassesData>>((ref) {
  return [];
});

final completedClassesProvider = StateProvider<List<ClassesData>>((ref) {
  return [];
});

final cancelledClassesProvider = StateProvider<List<ClassesData>>((ref) {
  return [];
});
*/

class UpComingListsNotifier extends StateNotifier<List<ClassesData>> {
  UpComingListsNotifier() : super([]);

  updateUpcoming(List<ClassesData> upcoming) {
    state = upcoming;
  }

  deleteAllUpcoming() {
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

final upcomingClassesProvider =
    StateNotifierProvider<UpComingListsNotifier, List<ClassesData>>(
  (ref) => UpComingListsNotifier(),
);

class CompletedListsNotifier extends StateNotifier<List<ClassesData>> {
  CompletedListsNotifier() : super([]);

  updateCompleted(List<ClassesData> upcoming) {
    state = upcoming;
  }

  deleteAllCompleted() {
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

final completedClassesProvider =
    StateNotifierProvider<CompletedListsNotifier, List<ClassesData>>(
  (ref) => CompletedListsNotifier(),
);

class CancelledListsNotifier extends StateNotifier<List<ClassesData>> {
  CancelledListsNotifier() : super([]);

  updateCancelled(List<ClassesData> upcoming) {
    state = upcoming;
  }

  deleteAllCancelled() {
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

final cancelledClassesProvider =
    StateNotifierProvider<CancelledListsNotifier, List<ClassesData>>(
  (ref) => CancelledListsNotifier(),
);

final studentNameProvider = StateProvider<String>((ref) {
  return '';
});

final studentOccupationProvider = StateProvider<String>((ref) {
  return '';
});

final slotDurationProvider = StateProvider<String>((ref) {
  return '';
});

final dateProvider = StateProvider<String>((ref) {
  return '';
});

final dayProvider = StateProvider<String>((ref) {
  return '';
});

final timeProvider = StateProvider<String>((ref) {
  return '';
});

final budgetProvider = StateProvider<String>((ref) {
  return '';
});
