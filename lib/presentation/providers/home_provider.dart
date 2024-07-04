import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/app/utils/ui_snackbars.dart';
import 'package:moss_yoga/data/models/pre_booking_session_request_model.dart';
import 'package:moss_yoga/data/models/teacher_detail_schedule_response.dart';
import 'package:moss_yoga/data/models/top_rated_teacher_response_model.dart';
import 'package:moss_yoga/data/models/yoga_poses_response_model.dart';
import 'package:moss_yoga/data/models/yoga_styles_response_model.dart';
import 'package:moss_yoga/data/repositories/home_repository.dart';
import 'package:moss_yoga/presentation/providers/screen_state.dart';
import '../../data/data_sources/user_local_data_source.dart';
import '../../data/models/login_response_model.dart';
import '../../data/network/error_handler_interceptor.dart';
import '../screens/students_screens/home/home_states.dart';

final homeNotifierProvider = StateNotifierProvider<HomeNotifier, HomeStates>(
  (ref) => HomeNotifier(
    ref: ref,
    homeRepository: GetIt.I<HomeRepository>(),
    userLocalDataSource: GetIt.I<UserLocalDataSource>(),
  ),
);

class HomeNotifier extends StateNotifier<HomeStates> {
  HomeNotifier(
      {required this.ref,
      required this.homeRepository,
      required this.userLocalDataSource})
      : super(HomeInitialState());

  final Ref ref;
  final HomeRepository homeRepository;
  final UserLocalDataSource userLocalDataSource;

  Future getPoses() async {
    if (ref.watch(allPosesProvider).isNotEmpty) {
      return;
    }
    try {
      state = HomeLoadingState();
      final response = await homeRepository.getPoses();

      ref.read(allPosesProvider).addAll(response);

      print("This is the pose name${ref.read(allPosesProvider)[0].poseName}");
      state = HomeSuccessfulState();
      print(response);
      return;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = HomeErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => ' ${error.messages?.join(", ")}')
            .join("\n");
        state = HomeErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = HomeErrorState(error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = HomeErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = HomeErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = HomeErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = HomeErrorState(error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future getYogaStyles() async {
    if (ref.watch(allYogaStylesProvider).isNotEmpty) {
      return;
    }
    try {
      state = HomeLoadingState();
      final response = await homeRepository.getYogaStyles();
      ref.read(allYogaStylesProvider).addAll(response);

      // print("This is the pose name" + ref.read(allPosesProvider)[0].poseName);
      state = HomeSuccessfulState();
      print(response);
      return;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = HomeErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.messages?.join(", ")}')
            .join("\n");
        state = HomeErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = HomeErrorState(error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = HomeErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = HomeErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = HomeErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = HomeErrorState(error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future getTopRatedTeachers() async {
    try {
      state = HomeLoadingState();
      final response = await homeRepository.getTopRatedTeachers();

      //ref.read(topRatedTeachersProvider).addAll(response);

      state = HomeSuccessfulState();

      final teacherListProvider = ref.read(topRatedTeachersProvider.notifier);
      teacherListProvider.deleteAllTeacher();
      teacherListProvider.updateTeachers(response);
      print(response);
      return;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = HomeErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = HomeErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = HomeErrorState(error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = HomeErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = HomeErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = HomeErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = HomeErrorState(error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future getTeacherDetailsSchedule({required int userId}) async {
    /* if (ref.watch(morningSlots).isNotEmpty) {
      return;
    } else if (ref.watch(afternoonSlots).isNotEmpty) {
      return;
    } else if (ref.watch(eveningSlots).isNotEmpty) {
      return;
    } else if (ref.watch(nightSlots).isNotEmpty) {
      return;
    } else if (ref.watch(availableDatesProvider).isNotEmpty) {
      return;
    }*/
    try {
      state = TeacherSessionScheduleLoadingState();
      final response = await homeRepository.getTeacherSchedule(userId: userId);

      //ref.read(allYogaStylesProvider).addAll(response);

      //print("This is the pose name" + ref.read(allPosesProvider)[0].poseName);
      state = TeacherSessionScheduleSuccessfulState();
      print("TEACHER ID================ ${response.teacherId}");

      /* ref.read(morningSlots).addAll(response.availability.morning);
      ref.read(afternoonSlots).addAll(response.availability.afternoon);
      ref.read(eveningSlots).addAll(response.availability.evening);
      ref.read(nightSlots).addAll(response.availability.night);*/

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
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = TeacherSessionScheduleErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = TeacherSessionScheduleErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = TeacherSessionScheduleErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = TeacherSessionScheduleErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = TeacherSessionScheduleErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = TeacherSessionScheduleErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = TeacherSessionScheduleErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future preBookSessionRequest(BuildContext context) async {
    PreBookingSessionRequest data = PreBookingSessionRequest(
      studentId: 0,
      teacherSchedulingDetailCode:
          ref.read(selectedDurationTeacherCodeProvider),
      bookingDate: ref.read(selectedDateProvider).toString(),
      paymentId: 0,
    );

    try {
      state = PreBookingSessionLoadingState();

      final response = await homeRepository.preBookSessionRequest(
          preBookingSessionRequest: data);

      state = PreBookingSessionSuccessfulState();
      UIFeedback.showSnackBar(
        context,
        "Your request Has Been Sent To Teacher!",
        height: 250,
        stateType: StateType.success,
      );
      print(response);
      //return;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = PreBookingSessionErrorState(
          error: e.message.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = PreBookingSessionErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = PreBookingSessionErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = PreBookingSessionErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = PreBookingSessionErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = PreBookingSessionErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = PreBookingSessionErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future getYouMayAlsoLike() async {
    if (ref.watch(youMayAlsoLikeProvider).isNotEmpty) {
      return;
    }
    try {
      state = HomeLoadingState();
      final response = await homeRepository.getYouMayAlsoLike();

      ref.read(youMayAlsoLikeProvider).addAll(response.message);

      print("This is the you may also like name" +
          ref.read(youMayAlsoLikeProvider)[0]);
      state = HomeSuccessfulState();
      print(response);
      return;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = HomeErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = HomeErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = HomeErrorState(error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = HomeErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = HomeErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = HomeErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = HomeErrorState(error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future getStudentData() async {
    LoginResponseModel? user = await userLocalDataSource.getUser();
    print(user?.userType.toString());
    print(user?.email.toString());
    print(user?.userId.toString());
    print(user?.username.toString());
    ref.read(studentObjectProvider.notifier).state = user!;

    ref.read(nameProvider.notifier).state = user.username;
    ref.read(emailProvider.notifier).state = user.email;
    ref.read(studentIdProvider.notifier).state = user.userId;

    print("USER ID =========== ${ref.read(studentIdProvider.notifier).state}");
  }

  Future getUserDataSplashScreen() async {
    LoginResponseModel? user = await userLocalDataSource.getUser();
    if (user == null) {
      print(
          'inside provider method check for splash screen its null so goto login');
      return null;
    } else {
      print(
          'inside provider method check for splash screen its not null so goto home');
      ref.read(userObjectsplashProvider.notifier).state = user;

      return user;
    }
  }

// Assuming you have a function to update the teacher specialties list
  void updateTeacherSpecialitiesList(String teacherSpecialities) {
    final teacherSpecialityListState =
        ref.read(teacherSpecialityListProvider.notifier);

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
}

final allPosesProvider = Provider<List<PosesResponseModel>>((ref) {
  return [];
});

final allYogaStylesProvider = Provider<List<YogaStylesResponseModel>>((ref) {
  return [];
});

class TopRatedTeachersNotifier
    extends StateNotifier<List<TopRatedTeacherResponseModel>> {
  TopRatedTeachersNotifier() : super([]);

  updateTeachers(List<TopRatedTeacherResponseModel> teacher) {
    state = teacher;
  }

  deleteAllTeacher() {
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

final topRatedTeachersProvider = StateNotifierProvider<TopRatedTeachersNotifier,
    List<TopRatedTeacherResponseModel>>(
  (ref) => TopRatedTeachersNotifier(),
);

class SavedTeacherNotifier
    extends StateNotifier<List<TopRatedTeacherResponseModel>> {
  SavedTeacherNotifier() : super([]);

  void addTeacher(TopRatedTeacherResponseModel teacher) {
    state = [...state, teacher];
  }

  void deleteTeacher(int teacherId) {
    state = state.where((teacher) => teacher.teacherId != teacherId).toList();
  }
}

final savedTeacherProvider = StateNotifierProvider<SavedTeacherNotifier,
    List<TopRatedTeacherResponseModel>>(
  (ref) => SavedTeacherNotifier(),
);

final youMayAlsoLikeProvider = Provider<List<String>>((ref) {
  return [];
});

// final durationSlotsProivider = Provider<List<Slot>>((ref) => []);

//final durationSlotsProivider = Provider<List<Slot>>((ref) => []);

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

// final teacherScheduleResponseProvider = Provider<TeacherDetailScheduleResponse>(
//   (ref) => TeacherDetailScheduleResponse(
//     teacherId: 0,
//     slots: [],
//     availability: Availability(
//       availableDates: [],
//       morning: [],
//       evening: [],
//       night: [],
//       afternoon: [],
//     ),
//   ),
// );

final studentObjectProvider = StateProvider<LoginResponseModel>((ref) =>
    LoginResponseModel(
        userId: -1,
        email: '',
        username: '',
        token: '-1',
        userType: 'userType',
        message: 'message',
        isVerified: false));
final userObjectsplashProvider = StateProvider<LoginResponseModel>((ref) =>
    LoginResponseModel(
        userId: -1,
        email: '',
        username: '',
        token: '-1',
        userType: 'userType',
        message: 'message',
        isVerified: false));


final userVerificationStatusProvider = StateProvider<bool>((ref) {
  return false;
});

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

class EmailNotifier extends StateNotifier<String> {
  EmailNotifier() : super('');

  updateEmail(String email) {
    state = email;
  }

  deleteEmail() {
    state = ''; // Set the state to an empty list to delete all teachers
  }

  // Cancel any active subscriptions or event listeners here
  @override
  void dispose() {
    super.dispose();
  }
}

final emailProvider = StateNotifierProvider<EmailNotifier, String>(
  (ref) => EmailNotifier(),
);

class NameNotifier extends StateNotifier<String> {
  NameNotifier() : super('');

  updatename(String name) {
    state = name;
  }

  deleteName() {
    state = ''; // Set the state to an empty list to delete all teachers
  }

  // Cancel any active subscriptions or event listeners here
  @override
  void dispose() {
    super.dispose();
  }
}

final nameProvider = StateNotifierProvider<NameNotifier, String>(
  (ref) => NameNotifier(),
);

final teacherNameProvider = StateProvider<String>((ref) {
  return "";
});

final teacherOccupationProvider = StateProvider<String>((ref) {
  return "";
});

final teacherAboutProvider = StateProvider<String>((ref) {
  return "";
});

final teacherRatingProvider = StateProvider<String>((ref) {
  return "";
});

final teacherPriceProvider = StateProvider<String>((ref) {
  return "";
});

final teacherCityProvider = StateProvider<String>((ref) {
  return "";
});

final teacherSpecialityListProvider = StateProvider<List<String>>((ref) {
  return [];
});
