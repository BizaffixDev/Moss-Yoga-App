import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/models/my_class_student_request_model.dart';
import 'package:moss_yoga/data/models/my_classes_student_response_model.dart';
import 'package:moss_yoga/data/models/reshedule_session_request_model.dart';
import 'package:moss_yoga/data/repositories/my_classes_student_repository.dart';
import 'package:moss_yoga/presentation/providers/screen_state.dart';
import 'package:moss_yoga/presentation/screens/students_screens/my_classes/my_classes_states.dart';

import '../../data/data_sources/user_local_data_source.dart';
import '../../data/models/login_response_model.dart';
import '../../data/models/teacher_detail_schedule_response.dart';
import '../../data/network/error_handler_interceptor.dart';


final myClassesStudentNotifierProvider =
    StateNotifierProvider<MyClassesStudentNotifier, MyClassesStudentStates>(
  (ref) => MyClassesStudentNotifier(
    ref: ref,
    myClassesStudentRepository: GetIt.I<MyClassesStudentRepository>(),
    userLocalDataSource: GetIt.I<UserLocalDataSource>(),
  ),
);

class MyClassesStudentNotifier extends StateNotifier<MyClassesStudentStates> {
  MyClassesStudentNotifier({
    required this.ref,
    required this.myClassesStudentRepository,
    required this.userLocalDataSource,
  }) : super(MyClassesStudentInitialState());

  final Ref ref;
  final MyClassesStudentRepository myClassesStudentRepository;
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



    print("USER ID =========== ${ref.read(studentIdProvider.notifier).state}");
  }

  Future getMyClassesData({required String date}) async {
    print("STUDENT ID CHECK ===== ${ref.read(studentIdProvider)}");
    LoginResponseModel? user = await userLocalDataSource.getUser();

    MyClassStudentRequest data = MyClassStudentRequest(
      ///To Make it static if api breaks
      studentId: user!.userId.toString(),
      // studentId:
      //     //TODO: need to make this dynamic in future
      //     ref.read(studentIdProvider).toString(),
      date: date,
    );

    try {
      state = MyClassesStudentLoadingState();
      final response = await myClassesStudentRepository.myClassesData(
          myClassStudentRequest: data);
      state = MyClassesStudentSuccessfulState();

      print("UPCOMING List Data  ${response.upcoming}");

      // ref.read(upcomingClassesProvider).addAll(response.upcoming);
      // ref.read(cancelledClassesProvider).addAll(response.cancelled);
      // ref.read(completedClassesProvider).addAll(response.confirmed);

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
      state = MyClassesStudentErrorState(
          error: e.message, errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = MyClassesStudentErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = MyClassesStudentErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = MyClassesStudentErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = MyClassesStudentErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = MyClassesStudentErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = MyClassesStudentErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future cancelBooking({required String bookingCode}) async {
    try {
      state = CancelBookingStudentLoadingState();
      final response = await myClassesStudentRepository.cancelBooking(
          bookingCode: bookingCode);
      state = CancelBookingStudentSuccessfulState();

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
      state = CancelBookingStudentErrorState(
          error: e.message, errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = CancelBookingStudentErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = CancelBookingStudentErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = CancelBookingStudentErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = CancelBookingStudentErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = CancelBookingStudentErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = CancelBookingStudentErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  // Assuming you have a function to update the teacher specialties list
  void updateTeacherSpecialitiesListReshedule(String teacherSpecialities) {
    final teacherSpecialityListState =
        ref.read(teacherSpecialityListRescheduleProvider.notifier);

    if (teacherSpecialities.isNotEmpty) {
      final specialtiesList = teacherSpecialities
          .split(',')
          .map((speciality) => speciality.trim())
          .toList();
      teacherSpecialityListState.state = specialtiesList;
    } else {
      teacherSpecialityListState.state = [];
    }
  }

  Future rescheduleBooking({
    required String bookingDate,
    required String bookingCode,
    required String teacherSchedulingDetailCode,
    required int paymentId,
  }) async {
    RescheduleSessionRequest data = RescheduleSessionRequest(
      bookingCode: bookingCode,
      studentId: ref.read(studentIdProvider),
      teacherSchedulingDetailCode: teacherSchedulingDetailCode,
      bookingDate: bookingDate,
      paymentId: paymentId,
    );

    try {
      state = RescheduleBookingStudentLoadingState();
      final response = await myClassesStudentRepository.rescheduleSession(
          rescheduleSessionRequest: data);


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
      state = RescheduleBookingStudentSuccessfulState();

    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = RescheduleBookingStudentErrorState(
          error: e.message, errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = RescheduleBookingStudentErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = RescheduleBookingStudentErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = RescheduleBookingStudentErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = RescheduleBookingStudentErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = RescheduleBookingStudentErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = RescheduleBookingStudentErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future getRescheduleTeacherDetails({
    required String bookingId,
  }) async {
    try {
      state = RescheduleTeacherDetailsLoadingState();
      final response = await myClassesStudentRepository
          .getRescheduleTeacherDetails(bookingId: bookingId);

      final morningSlotsProvider = ref.read(morningSlots.notifier);
      final eveningSlotsProvider = ref.read(eveningSlots.notifier);
      final afternoonSlotsProvider = ref.read(afternoonSlots.notifier);
      final nightSlotsProvider = ref.read(nightSlots.notifier);
      final datesProvider = ref.read(availableDatesProvider.notifier);
      final durationSLots = ref.read(durationSlotsProivider.notifier);

      morningSlotsProvider.deleteAllMorning();
      morningSlotsProvider.updateMorning(response.availability.morning);
      eveningSlotsProvider.deleteAllEvening();
      eveningSlotsProvider.updateEvening(response.availability.evening);
      afternoonSlotsProvider.deleteAllAfternoon();
      afternoonSlotsProvider.updateAfternoon(response.availability.afternoon);
      nightSlotsProvider.deleteAllNight();
      nightSlotsProvider.updateNight(response.availability.night);
      datesProvider.deleteAllAvailableDates();
      datesProvider.updateAvailableDate(response.availability.availableDates);
      durationSLots.deleteAllSlots();
      durationSLots.updateSlots(response.slots);

      /* ref
          .read(availableDatesProvider)
          .addAll(response.availability.availableDates);*/

      //ref.read(durationSlotsProivider).clear();
      //ref.read(durationSlotsProivider).addAll(response.slots);
      print("MORNING SLOTS================ ${ref.read(morningSlots)}");
      print("AFTERNOON SLOTS================ ${ref.read(afternoonSlots)}");
      print("EVENING SLOTS================ ${ref.read(eveningSlots)}");
      print("NIGHT SLOTS================ ${ref.read(eveningSlots)}");
      print(
          "AVAILABLE DATES================ ${ref.read(availableDatesProvider)}");
      print(
          "DURATION SLOTS================ ${ref.read(durationSlotsProivider)}");
      state = RescheduleTeacherDetailsSuccessfulState();
      //return response;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = RescheduleTeacherDetailsErrorState(
          error: e.message, errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = RescheduleTeacherDetailsErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = RescheduleTeacherDetailsErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = RescheduleTeacherDetailsErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = RescheduleTeacherDetailsErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = RescheduleTeacherDetailsErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = RescheduleTeacherDetailsErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }
}

/*final upcomingClassesProvider = StateProvider<List<ClassesData>>((ref) {
  return [];
});*/

/*final completedClassesProvider = StateProvider<List<ClassesData>>((ref) {
  return [];
});*/

/*final cancelledClassesProvider = StateProvider<List<ClassesData>>((ref) {
  return [];
});*/

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


class SudentIdNotifier extends StateNotifier<int> {
  SudentIdNotifier() : super(-1);

  updateId(int id) {
    state = id;
  }

  deleteId() {
    state = -1; // Set the state to an empty list to delete all teachers
  }

  // Cancel any active subscriptions or event listeners here
  @override
  void dispose() {
    super.dispose();
  }
}

final studentIdProvider = StateNotifierProvider<SudentIdNotifier, int>(
      (ref) => SudentIdNotifier(),
);


final teacherIdProvider = StateProvider<int>((ref) {
  return 0;
});

final teacherNameMyClassProvider = StateProvider<String>((ref) {
  return '';
});

final teacherOccupationMyClassProvider = StateProvider<String>((ref) {
  return '';
});

final slotDurationMyClassProvider = StateProvider<String>((ref) {
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

final teacherSchedulingDetailCodeProvider = StateProvider<String>((ref) {
  return '';
});

final bookingCodeProvider = StateProvider<String>((ref) {
  return '';
});

final bookingDateProvider = StateProvider<String>((ref) {
  return '';
});

final teacherSpecialityListRescheduleProvider =
    StateProvider<List<String>>((ref) {
  return [];
});

final slotRecheduleProvider = StateProvider<String>((ref) {
  return '';
});


class DurationSlotsNotifier extends StateNotifier<List<Slot>> {
  DurationSlotsNotifier() : super([]);

  updateSlots(List<Slot> slot) {
    state = slot;
  }

  deleteAllSlots() {
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

final durationSlotsProivider =
StateNotifierProvider<DurationSlotsNotifier, List<Slot>>(
      (ref) => DurationSlotsNotifier(),
);

class MorningSlotsNotifier extends StateNotifier<List<dynamic>> {
  MorningSlotsNotifier() : super([]);

  updateMorning(List<dynamic> morning) {
    state = morning;
  }

  deleteAllMorning() {
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

final morningSlots = StateNotifierProvider<MorningSlotsNotifier, List<dynamic>>(
      (ref) => MorningSlotsNotifier(),
);

class EveningSlotsNotifier extends StateNotifier<List<dynamic>> {
  EveningSlotsNotifier() : super([]);

  updateEvening(List<dynamic> evening) {
    state = evening;
  }

  deleteAllEvening() {
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

final eveningSlots = StateNotifierProvider<EveningSlotsNotifier, List<dynamic>>(
      (ref) => EveningSlotsNotifier(),
);

class NightSlotsNotifier extends StateNotifier<List<dynamic>> {
  NightSlotsNotifier() : super([]);

  updateNight(List<dynamic> night) {
    state = night;
  }

  deleteAllNight() {
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

final nightSlots = StateNotifierProvider<NightSlotsNotifier, List<dynamic>>(
      (ref) => NightSlotsNotifier(),
);

class AfternoonSlotsNotifier extends StateNotifier<List<dynamic>> {
  AfternoonSlotsNotifier() : super([]);

  updateAfternoon(List<dynamic> afternoon) {
    state = afternoon;
  }

  deleteAllAfternoon() {
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

final afternoonSlots =
StateNotifierProvider<AfternoonSlotsNotifier, List<dynamic>>(
      (ref) => AfternoonSlotsNotifier(),
);

class AvailableDatessNotifier extends StateNotifier<List<String>> {
  AvailableDatessNotifier() : super([]);

  updateAvailableDate(List<String> availableDates) {
    state = availableDates;
  }

  deleteAllAvailableDates() {
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

final availableDatesProvider =
StateNotifierProvider<AvailableDatessNotifier, List<String>>(
      (ref) => AvailableDatessNotifier(),
);

final selectedMorningProvider = StateProvider<String>((ref) => "");
final selectedAfterNoonProvider = StateProvider<String>((ref) => "");
final selectedEveningProvider = StateProvider<String>((ref) => "");
final selectedNightProvider = StateProvider<String>((ref) => "");
final selectedDurationProvider = StateProvider<String>((ref) => "");
final selectedDurationPriceProvider = StateProvider<String>((ref) => "");
final selectedDurationTeacherCodeProvider = StateProvider<String>((ref) => "");
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
final selectedDatePreBookingProvider =
StateProvider<DateTime>((ref) => DateTime.now());