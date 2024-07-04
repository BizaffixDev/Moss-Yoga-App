import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/models/student_level.dart';
import 'package:moss_yoga/data/models/update_student_profile_request_model.dart';
import 'package:moss_yoga/data/models/user_gender_model.dart';
import 'package:moss_yoga/data/repositories/student_account_data_repository.dart';

import '../../../data/data_sources/user_local_data_source.dart';
import '../../../data/models/login_response_model.dart';
import '../../../data/network/error_handler_interceptor.dart';
import '../../screens/students_screens/student_profile_setting/student_account_states.dart';
import '../screen_state.dart';

final studentAccountNotifierProvider =
    StateNotifierProvider<StudentAccountNotifier, StudentAccountStates>(
  (ref) => StudentAccountNotifier(
    ref: ref,
    studentChangePasswdRepository: GetIt.I<StudentAccountRepository>(),
    userLocalDataSource: GetIt.I<UserLocalDataSource>(),
  ),
);

class StudentAccountNotifier extends StateNotifier<StudentAccountStates> {
  StudentAccountNotifier(
      {required this.ref,
      required this.studentChangePasswdRepository,
      required this.userLocalDataSource})
      : super(StudentAccountInitialState());

  final Ref ref;
  final StudentAccountRepository studentChangePasswdRepository;
  final UserLocalDataSource userLocalDataSource;

  Future changePassword(
      {required String email,
      required String currentpasswd,
      required String changepasswd,
      required String reenterpasswd}) async {
    try {
      state = StudentChangePasswordLoadingState();
      final response = await studentChangePasswdRepository
          .getStudentChangePasswordCredentials(
        email: email,
        currentpasswd: currentpasswd,
        changepasswd: changepasswd,
        reenterpasswd: reenterpasswd,
      );

      state = StudentChangePasswordSuccessfulState();
      // debugPrint(response);
      print("CHANGE PASSWORD RESPONSE ====  $response");
      return;
    } on UnauthorizedException catch (e) {
      debugPrint('This is the unauthorized part');
      state = StudentChangePasswordErrorState(
          error: e.message, errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.messages?.join(", ")}')
            .join("\n");
        state = StudentChangePasswordErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        debugPrint('going inside this BackendResponseError block bro');

        state = StudentChangePasswordErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        debugPrint('I guess it should be here');
        state = StudentChangePasswordErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      debugPrint('going inside this NoInternetConnectionException block bro');
      state = StudentChangePasswordErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      debugPrint('going inside this DioError block bro');
      debugPrint("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = StudentChangePasswordErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        debugPrint('ERROR RESPONSE: $errorResponse');
        debugPrint('Title: $title');
      }
      debugPrint(e.toString());
      state = StudentChangePasswordErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future deleteAccount({
    required int userId,
  }) async {
    try {
      state = StudentDeleteAccountLoadingState();
      final response = await studentChangePasswdRepository.deleteAccountStudent(
        userId: userId,
      );

      state = StudentDeleteAccountSuccessfulState();
      // debugPrint(response);
      print("DELETE ACCOUNT RESPONSE ====  $response");
      return;
    } on UnauthorizedException catch (e) {
      debugPrint('This is the unauthorized part');
      state = StudentDeleteAccountErrorState(
          error: e.message, errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.messages?.join(", ")}')
            .join("\n");
        state = StudentDeleteAccountErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        debugPrint('going inside this BackendResponseError block bro');

        state = StudentDeleteAccountErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        debugPrint('I guess it should be here');
        state = StudentDeleteAccountErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      debugPrint('going inside this NoInternetConnectionException block bro');
      state = StudentDeleteAccountErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      debugPrint('going inside this DioError block bro');
      debugPrint("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = StudentDeleteAccountErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        debugPrint('ERROR RESPONSE: $errorResponse');
        debugPrint('Title: $title');
      }
      debugPrint(e.toString());
      state = StudentDeleteAccountErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future getProfileDetails() async {
    final userModel = await userLocalDataSource.getUser();
    try {
      state = StudentProfileDetailsLoadingState();
      final response = await studentChangePasswdRepository
          .getStudentProfileDetails(userId: userModel!.userId);

      ref.read(studentIdProvider.notifier).state = response.userId;
      ref.read(emailProvider.notifier).state = response.studentEmail;
      ref.read(nameProvider.notifier).state = response.studentName;
      ref.read(dobProvider.notifier).state = response.dateOfBirth;
      ref.read(genderProvider.notifier).state = response.gender;
      ref.read(traumaProvider.notifier).state = response.trauma;
      ref.read(intentionProvider.notifier).state = response.userIntentions;
      if (response.userLevel == StudentLevel.Beginner.name) {
        ref.read(levelProvider.notifier).state = StudentLevel.Beginner.name;
      } else if (response.userLevel == StudentLevel.Advanced.name) {
        ref.read(levelProvider.notifier).state = StudentLevel.Advanced.name;
      } else if (response.userLevel == StudentLevel.Intermediate.name) {
        ref.read(levelProvider.notifier).state = StudentLevel.Intermediate.name;
      } else {
        // Handle the case where the newValue doesn't match any enum value.
        // You might want to set a default value or handle it as needed.
        ref.read(levelProvider.notifier).state =
            StudentLevel.Beginner.name; // Set a default value here.
      }
      // ref.read(levelProvider.notifier).state = response.userLevel;

      ref.read(otherChronicProvider.notifier).state = response.chronicalOthers;

      updateChronicList(response.userChronicalCondition);

      //chronic.deleteChronic();
      //chronic.updateChrnonic(response.userChronicalCondition);

      state = StudentProfileDetailsSuccessfulState();
      // debugPrint(response);
      print("USER DETAIL RESPONSE ====  $response");
      return;
    } on UnauthorizedException catch (e) {
      debugPrint('This is the unauthorized part');
      state = StudentProfileDetailsErrorState(
          error: e.message, errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.messages?.join(", ")}')
            .join("\n");
        state = StudentProfileDetailsErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        debugPrint('going inside this BackendResponseError block bro');

        state = StudentProfileDetailsErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        debugPrint('I guess it should be here');
        state = StudentProfileDetailsErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      debugPrint('going inside this NoInternetConnectionException block bro');
      state = StudentProfileDetailsErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      debugPrint('going inside this DioError block bro');
      debugPrint("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = StudentProfileDetailsErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        debugPrint('ERROR RESPONSE: $errorResponse');
        debugPrint('Title: $title');
      }
      debugPrint(e.toString());
      state = StudentProfileDetailsErrorState(
          error: e.toString(), errorType: ErrorType.other);
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

  // Assuming you have a function to update the teacher specialties list
  Future updateChronicList(String chronicConditions) async {
    final chronicConditionListState =
        ref.read(chronicConditionProvider.notifier);

    if (chronicConditions.isNotEmpty) {
      final conditionList = chronicConditions
          .split(',')
          .map((speciality) => speciality.trim())
          .toList();
      chronicConditionListState.state = conditionList;
      ref.read(chronicConditionProvider.notifier).state = conditionList;
    } else {
      chronicConditionListState.state = [];
    }
  }

  Future updateStudentProfile(
      {required String trauma,
      required String dob,
      required String gender}) async {
    // final userChronicalList = ref.watch(chronicConditionProvider);
    // final userPhysicalList = ref.read(physicalConditionRequestProvider);
    //final usertrauma = ref.read(traumaProvider);
    //final userHasSurgery = ref.read(userHasSurgeryProvider);

    final userModel = await userLocalDataSource.getUser();

    //debugPrint("CHRONICAL LIST====== $userChronicalList");
    //debugPrint("USER TRAUMA====== $userChronicalList");
    print("USER ID === ===== ==== ${userModel!.userId}");

    UpdateStudentProfileRequest data = UpdateStudentProfileRequest(

      userId: userModel.userId,
      userIntentions: "",
      userLevel: ref.read(levelProvider),
      userChronicalCondition: ref.read(chronicConditionProvider),
      userPhysicalCondition: [],
      haveInjury: "No",
      genderId: gender,
      trauma: trauma,
      phoneNum: "",
      occupation: "",
      country: "",
      city: "",
      dob: dob,
      placeOfBirth: "",
      chronicalOthers: "",
      physicalOthers: "",
    );

    try {
      state = UpdateStudentProfileDetailsLoadingState();

      final response = await studentChangePasswdRepository
          .updateStudentProfileDetails(data: data);

      debugPrint(response.toString());
      state = UpdateStudentProfileDetailsSuccessfulState();

      //return;
    } on UnauthorizedException catch (e) {
      debugPrint('This is the unauthorized part');
      state = UpdateStudentProfileDetailsErrorState(
          error: e.message.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.messages?.join(", ")}')
            .join("\n");
        state = UpdateStudentProfileDetailsErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        debugPrint('going inside this BackendResponseError block bro');

        state = UpdateStudentProfileDetailsErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        debugPrint('I guess it should be here');
        state = UpdateStudentProfileDetailsErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      debugPrint('going inside this NoInternetConnectionException block bro');
      state = UpdateStudentProfileDetailsErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      debugPrint('going inside this DioError block bro');
      debugPrint("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = UpdateStudentProfileDetailsErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }else if (e.response?.statusCode == 500) {
        state = UpdateStudentProfileDetailsErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        debugPrint('ERROR RESPONSE: $errorResponse');
        debugPrint('Title: $title');
      }
      debugPrint(e.toString());
      state = UpdateStudentProfileDetailsErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }
}

final studentObjectProvider = StateProvider<LoginResponseModel>((ref) =>
    LoginResponseModel(
        userId: -1,
        email: '',
        username: '',
        token: '-1',
        userType: 'userType',
        message: 'message',
        isVerified: false));

final studentIdProvider = StateProvider<int>((ref) {
  return 0;
});

final emailProvider = StateProvider<String>((ref) {
  return "";
});

final nameProvider = StateProvider<String>((ref) {
  return "";
});

final levelProvider = StateProvider<String>((ref) {
  return StudentLevel.Beginner.name;
});

final dobProvider = StateProvider<String>((ref) {
  return "";
});

final genderProvider = StateProvider<String>((ref) {
  return UserGender.female.toString();
});

final traumaProvider = StateProvider<String>((ref) {
  return "";
});

final intentionProvider = StateProvider<String>((ref) {
  return "";
});

final otherChronicProvider = StateProvider<String>((ref) {
  return "";
});

class ChronicConditionNotifier extends StateNotifier<List<String>> {
  ChronicConditionNotifier() : super([]);

  // updateChrnonic(String chronic) {
  //   state = chronic;
  // }

  void addChronic(String condition) {
    state = [...state, condition];
  }

  void deleteChronicAtIndex(int index) {
    if (index >= 0 && index < state.length) {
      state = List.from(state)..removeAt(index);
    }
  }

  // Cancel any active subscriptions or event listeners here
  @override
  void dispose() {
    super.dispose();
  }
}

final chronicConditionProvider =
    StateNotifierProvider<ChronicConditionNotifier, List<String>>(
  (ref) => ChronicConditionNotifier(),
);
