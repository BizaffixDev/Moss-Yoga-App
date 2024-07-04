import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/data_sources/user_local_data_source.dart';
import 'package:moss_yoga/data/models/add_schedule_teacher_request_model.dart';
import 'package:moss_yoga/data/models/get_teacher_no_of_session_response_model.dart';
import 'package:moss_yoga/data/models/login_response_model.dart';
import 'package:moss_yoga/data/models/top_rated_teacher_response_model.dart';
import 'package:moss_yoga/data/models/yoga_poses_response_model.dart';
import 'package:moss_yoga/data/models/yoga_styles_response_model.dart';
import 'package:moss_yoga/data/repositories/teacher_repositories/teacher_home_repository.dart';
import 'package:moss_yoga/presentation/providers/screen_state.dart';
import 'package:moss_yoga/presentation/screens/teachers_screens/home/states/home_teacher_states.dart';

import '../../../data/models/upcoming_classes_home_response_model.dart';
import '../../../data/network/error_handler_interceptor.dart';

final homeNotifierTeacherProvider =
    StateNotifierProvider<HomeTeacherNotifier, TeacherHomeStates>(
  (ref) => HomeTeacherNotifier(
    ref: ref,
    teacherHomeRepository: GetIt.I<TeacherHomeRepository>(),
    userLocalDataSource: GetIt.I<UserLocalDataSource>(),
  ),
);

class HomeTeacherNotifier extends StateNotifier<TeacherHomeStates> {
  HomeTeacherNotifier(
      {required this.ref,
      required this.teacherHomeRepository,
      required this.userLocalDataSource})
      : super(TeacherHomeInitialState());

  final Ref ref;
  final TeacherHomeRepository teacherHomeRepository;
  final UserLocalDataSource userLocalDataSource;

  Future getTeacherName() async {
    LoginResponseModel? user = await userLocalDataSource.getUser();
    print(
        "This is the user type when getting getTeacherName ${user?.userType.toString()}");
    print(user?.email.toString());
    print(user?.userId.toString());
    print(user?.username.toString());
    ref.read(teacherObjectProvider.notifier).state = user!;
    print("USER DATA MODEL =========== $user");
  }

  Future getNoOfSessions({required int id}) async {
    if (ref.read(getNoOfSessionsTeacherProvider).totalHours != -1 ||
        ref.read(getNoOfSessionsTeacherProvider).spendHours != -1) {
      return;
    }
    try {
      state = TeacherHomeLoadingState();
      final response = await teacherHomeRepository.getNoOfSessions(id: id);
      ref.read(getNoOfSessionsTeacherProvider.notifier).state = response;
      // print(response);
      state = TeacherHomeNoOfSessionsSuccessfulState();
      return;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = TeacherHomeNoOfSessionsErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.messages?.join(", ")}')
            .join("\n");
        state = TeacherHomeNoOfSessionsErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = TeacherHomeNoOfSessionsErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = TeacherHomeNoOfSessionsErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = TeacherHomeNoOfSessionsErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = TeacherHomeNoOfSessionsErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = TeacherHomeNoOfSessionsErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future getPoses() async {
    if (ref.watch(teacherAllPosesProvider).isNotEmpty) {
      return;
    }
    try {
      state = TeacherHomeLoadingState();
      final response = await teacherHomeRepository.getPoses();

      ref.read(teacherAllPosesProvider).addAll(response);

      // print("This is the pose name" +
      //     ref.read(teacherAllPosesProvider)[0].poseName);
      state = TeacherHomeSuccessfulState();
      print(response);
      return;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = TeacherHomeErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = TeacherHomeErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = TeacherHomeErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state =
            TeacherHomeErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state =
          TeacherHomeErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = TeacherHomeErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      } else
        print(e.toString());
      state = TeacherHomeErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future getYogaStyles() async {
    if (ref.watch(teacherAllYogaStylesProvider).isNotEmpty) {
      return;
    }
    try {
      state = TeacherHomeLoadingState();
      final response = await teacherHomeRepository.getYogaStyles();

      ref.read(teacherAllYogaStylesProvider).addAll(response);

      state = TeacherHomeSuccessfulState();
      print(response);
      return;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = TeacherHomeErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = TeacherHomeErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = TeacherHomeErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state =
            TeacherHomeErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state =
          TeacherHomeErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = TeacherHomeErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = TeacherHomeErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future changeOnlineStatusForTeacher({required bool change}) async {
    try {
      state = TeacherHomeLoadingState();
      var response = await teacherHomeRepository.changeOnlineStatusForTeacher(
          value: change);

      if (response.onlineStatus == 'Online') {
        print('Inside response online status ${response.onlineStatus}');

        ref.read(onlineProvider.notifier).changeOnline(true);
        state = TeacherHomeOnDemandButtonSuccessfulState();
      } else if (response.onlineStatus == 'Offline') {
        print(response.onlineStatus);
        ref.read(onlineProvider.notifier).changeOnline(false);
        state = TeacherHomeOnDemandButtonOfflineSuccessfulState();
      }
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = TeacherHomeOnDemandButtonErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.messages?.join(", ")}')
            .join("\n");
        state = TeacherHomeOnDemandButtonErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = TeacherHomeOnDemandButtonErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = TeacherHomeOnDemandButtonErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = TeacherHomeOnDemandButtonErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = TeacherHomeOnDemandButtonErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = TeacherHomeOnDemandButtonErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future getOnlineStatusForTeacher({required String teacherId}) async {
    try {
      state = TeacherHomeLoadingState();
      var response = await teacherHomeRepository.getOnlineStatusForTeacher(
          teacherId: teacherId);

      if (response.message == true) {
        print('Inside response online status ${response.message}');
        ref.read(onlineProvider.notifier).changeOnline(true);
        state = TeacherHomeOnDemandButtonSuccessfulState();
      } else if (response.message == false) {
        print(response.message);
        ref.read(onlineProvider.notifier).changeOnline(false);
        state = TeacherHomeOnDemandButtonOfflineSuccessfulState();
      }
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = TeacherHomeOnDemandButtonErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.messages?.join(", ")}')
            .join("\n");
        state = TeacherHomeOnDemandButtonErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = TeacherHomeOnDemandButtonErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = TeacherHomeOnDemandButtonErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = TeacherHomeOnDemandButtonErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = TeacherHomeOnDemandButtonErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = TeacherHomeOnDemandButtonErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future addScheduleByTeacher() async {
    AddScheduleTeacherRequest data = AddScheduleTeacherRequest(
      teacherId: ref.read(teacherIdProvider),
      availableDates: ref.read(scheduleDateTeacherListProvider),
      startTime: ref.read(scheduleTimeStartTeacherListProvider),
      endTime: ref.read(scheduleTimeEndTeacherListProvider),
      setPricing: [
        SetPricing(
          pricing: ref.read(scheduleBudgetFirstTeacherProvider),
          slotTime: ref.read(scheduleSlotFirstTimeTeacherProvider),
        ),
        SetPricing(
          pricing: ref.read(scheduleBudgetSecondTeacherProvider),
          slotTime: ref.read(scheduleSlotSecondTimeTeacherProvider),
        ),
        SetPricing(
          pricing: ref.read(scheduleBudgetThirdTeacherProvider),
          slotTime: ref.read(scheduleSlotThirdTimeTeacherProvider),
        )
      ],
    );

    try {
      state = ScheduleDateTimeLoadingState();
      final response = await teacherHomeRepository.addScheduleDateTimeTeachers(
          addScheduleTeacherRequest: data);

      // print("This is the pose name" +
      //     ref.read(allPosesTeacherProvider)[0].poseName);
      state = ScheduleDateTimeSuccessfulState();
      print(response);
      return;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = ScheduleDateTimeErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.messages?.join(", ")}')
            .join("\n");
        state = ScheduleDateTimeErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);

      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = ScheduleDateTimeErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = ScheduleDateTimeErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = ScheduleDateTimeErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = ScheduleDateTimeErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = ScheduleDateTimeErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future getUpcomingClasses({required int id}) async {
    if (ref.read(upComingClassesListProvider).isNotEmpty) {
      return;
    }
    try {
      state = TeacherHomeLoadingState();
      final response = await teacherHomeRepository.getUpcomingClasses(id: id);

      ref.read(upComingClassesListProvider).clear();
      ref.read(upComingClassesListProvider).addAll(response.upcoming);
      state = TeacherHomeSuccessfulState();
      print(response);
      return;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = TeacherHomeErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = TeacherHomeErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = TeacherHomeErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state =
            TeacherHomeErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state =
          TeacherHomeErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = TeacherHomeErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = TeacherHomeErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future getYouMayAlsoLike() async {
    if (ref.watch(youMayAlsoLikeProvider).isNotEmpty) {
      return;
    }
    try {
      state = TeacherHomeLoadingState();
      final response = await teacherHomeRepository.getYouMayAlsoLike();

      ref.read(youMayAlsoLikeProvider).addAll(response.message);

      print("This is the you may also like name" +
          ref.read(youMayAlsoLikeProvider)[0]);
      state = TeacherHomeSuccessfulState();
      print(response);
      return;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = TeacherHomeErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = TeacherHomeErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = TeacherHomeErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state =
            TeacherHomeErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state =
          TeacherHomeErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = TeacherHomeErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = TeacherHomeErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future getTeacherData() async {
    LoginResponseModel? user = await userLocalDataSource.getUser();
    print(user?.userType.toString());
    print(user?.email.toString());
    print(user?.userId.toString());
    print(user?.username.toString());
    ref.read(teacherObjectProvider.notifier).state = user!;

    ref.read(nameProvider.notifier).state = user.username;
    ref.read(emailProvider.notifier).state = user.email;
    ref.read(teacherIdProvider.notifier).state = user.userId;

    print("USER ID =========== ${ref.read(teacherIdProvider.notifier).state}");
  }
}

class OnlineNotifier extends StateNotifier<bool> {
  OnlineNotifier() : super(false);

  void changeOnline(bool isOnline) {
    state = isOnline;
  }
}

final onlineProvider = StateNotifierProvider<OnlineNotifier, bool>((ref) {
  return OnlineNotifier();
});

class TeacherIdNotifier extends StateNotifier<int> {
  TeacherIdNotifier() : super(-1);

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

final teacherIdProvider = StateNotifierProvider<TeacherIdNotifier, int>(
  (ref) => TeacherIdNotifier(),
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

final upComingClassesListProvider = Provider<List<UpcomingData>>((ref) {
  return [];
});

final teacherAllPosesProvider = Provider<List<PosesResponseModel>>((ref) {
  return [];
});

final teacherAllYogaStylesProvider =
    Provider<List<YogaStylesResponseModel>>((ref) {
  return [];
});

final topRatedTeachersProvider =
    Provider<List<TopRatedTeacherResponseModel>>((ref) {
  return [];
});

final youMayAlsoLikeProvider = Provider<List<String>>((ref) {
  return [];
});

//TODO: TEACHER DASHBOARDS PROVIDERS

final scheduleDateTeacherListProvider = StateProvider<List<String>>(
  (ref) {
    return [];
  },
);

final scheduleTimeStartTeacherListProvider = StateProvider<String>(
  (ref) {
    return "";
  },
);

final scheduleTimeEndTeacherListProvider = StateProvider<String>(
  (ref) {
    return "";
  },
);

final scheduleSlotFirstTimeTeacherProvider = StateProvider<String>(
  (ref) {
    return "";
  },
);

final scheduleSlotSecondTimeTeacherProvider = StateProvider<String>(
  (ref) {
    return "";
  },
);

final scheduleSlotThirdTimeTeacherProvider = StateProvider<String>(
  (ref) {
    return "";
  },
);

final scheduleBudgetFirstTeacherProvider = StateProvider<String>(
  (ref) {
    return "";
  },
);

final scheduleBudgetSecondTeacherProvider = StateProvider<String>(
  (ref) {
    return "";
  },
);

final scheduleBudgetThirdTeacherProvider = StateProvider<String>(
  (ref) {
    return "";
  },
);

final scheduleSetPricingTeacherListProvider = StateProvider<List<SetPricing>>(
  (ref) {
    return [
      SetPricing(pricing: "", slotTime: ""),
    ];
  },
);

final getNoOfSessionsTeacherProvider =
    StateProvider<GetTeacherNoOfSessionResponseModel>((ref) =>
        GetTeacherNoOfSessionResponseModel(
            spendHours: -1, totalHours: -1, sessionCount: -1));

final styleNameProvider = StateProvider<String>((ref) => "");
final styleImageProvider = StateProvider<String>((ref) => "");
final styleShortDescriptionProvider = StateProvider<String>((ref) => "");
final styleLongDescriptionProvider = StateProvider<String>((ref) => "");

final poseNameProvider = StateProvider<String>((ref) => "");
final poseImageProvider = StateProvider<String>((ref) => "");
final poseShortDescriptionProvider = StateProvider<String>((ref) => "");
final poseLongDescriptionProvider = StateProvider<String>((ref) => "");
final teacherObjectProvider = StateProvider<LoginResponseModel>((ref) =>
    LoginResponseModel(
        userId: -1,
        email: '',
        username: '',
        token: '-1',
        userType: 'userType',
        message: 'message',
        isVerified: false));
