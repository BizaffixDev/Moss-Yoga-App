import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moss_yoga/data/data_sources/user_local_data_source.dart';
import 'package:moss_yoga/data/models/chronic_response_model.dart';
import 'package:moss_yoga/data/models/fcm_device_token_request_model.dart';
import 'package:moss_yoga/data/models/forgot_password_response_model.dart';
import 'package:moss_yoga/data/models/physical_response_model.dart';
import 'package:moss_yoga/data/models/surgery_model.dart';
import 'package:moss_yoga/data/models/teacher_profile_status.dart';
import 'package:moss_yoga/data/models/user_gender_model.dart';
import 'package:moss_yoga/data/models/user_role.dart';
import 'package:moss_yoga/data/repositories/chronic_data_repository.dart';
import 'package:moss_yoga/data/repositories/login_data_repository.dart';
import 'package:moss_yoga/data/repositories/physical_data_repository.dart';
import 'package:moss_yoga/presentation/providers/app_providers.dart';
import 'package:moss_yoga/presentation/providers/home_provider.dart';
import 'package:moss_yoga/presentation/providers/screen_state.dart';
import 'package:moss_yoga/presentation/providers/teachers_providers/home_teacher_provider.dart';
import 'package:moss_yoga/presentation/screens/auth/login/states/login_states.dart';
import '../../data/google_sign_in.dart';
import '../../data/models/login_response_model.dart';
import '../../data/models/student_detail_request_model.dart';
import '../../data/models/student_profiling_conditions.dart';
import '../../data/models/user_intention.dart';
import '../../data/models/user_level.dart';
import '../../data/network/error_handler_interceptor.dart';

///This is the provider for the AuthNotifier Below,
///use this whereever you need authNotifier methods.
final authNotifyProvider =
    StateNotifierProvider.autoDispose<AuthNotifier, AuthStates>((ref) {
  return AuthNotifier(
    loginRepository: GetIt.I<LoginRepository>(),
    userLocalDataSource: GetIt.I<UserLocalDataSource>(),
    chronicRepository: GetIt.I<ChronicRepository>(),
    physicalRepository: GetIt.I<PhysicalRepository>(),
    googleSignInObject: GetIt.I<GoogleSignInApi>(),
    // loginRepository: LoginRepositoryImpl(),
    ref: ref,
  );
});

/// STATE NOTIFIER ONLY NOTIFIES ITS CHILDREN ANYWHERE THEY ARE IN THE APP.

class AuthNotifier extends StateNotifier<AuthStates> {
  // AuthNotifier(
  //     {required this.ref,
  //     required this.loginRepository,
  //     required this.userLocalDataSource})
  //     : super(AuthInitialState());
  AuthNotifier({
    required this.ref,
    required this.loginRepository,
    required this.chronicRepository,
    required this.physicalRepository,
    required this.userLocalDataSource,
    required this.googleSignInObject,
  }) : super(AuthInitialState());

  final Ref ref;
  final LoginRepository loginRepository;
  final UserLocalDataSource userLocalDataSource;
  final ChronicRepository chronicRepository;
  final PhysicalRepository physicalRepository;
  final GoogleSignInApi googleSignInObject;

  Future login(BuildContext context,
      {required String email, required String password}) async {
    try {
      state = LoginLoadingState();
      final response = await loginRepository.getLoginCredentials(
          email: email, password: password);
      await userLocalDataSource.persistUser(response);
      debugPrint("This is the userType sir ${response.userType}");
      ref.read(userVerificationStatusProvider.notifier).state = response.isVerified;
      ///Send to dual login screen
      if (response.userType == UserRole.Both.name) {
        debugPrint('Inside LoginSuccessfulBothUserTypesState');
        state = LoginSuccessfulBothUserTypesState(loginResponseModel: response);
      }

      ///Send to Teacher Screen but check which one
      else if (response.userType == UserRole.Teacher.name) {
        ///Send to Teacher Home Screen Verified
        if (response.isVerified == true) {
          ///update the teacherLocked provider value;
          ref.read(isLockedTeacherProvider.notifier).state = true;
          debugPrint(
              'Inside LoginSuccessful Teacher Type ${response.isVerified}should be true');



          state = LoginSuccessfulTeacherState(isVerified: true);
        }

        ///Send to Teacher Locked Screen
        else {
          ///update the teacherLocked provider value;
          ref.read(isLockedTeacherProvider.notifier).state = false;
          debugPrint(
              'Inside LoginSuccessful Teacher Type ${response.isVerified} should be false');
          state = LoginSuccessfulTeacherState(isVerified: false);
        }
      }

      ///Send to Student Home Screen
      else {
        debugPrint('Inside else block of Success LoginSuccessfulState');
        state = LoginSuccessfulState();
      }
    } on UnauthorizedException catch (_) {
      debugPrint('This is the unauthorized part');
      state = LoginErrorState(
          // error: e.errorText.toString(), errorType: ErrorType.inline);
          error: ' Invalid credentials',
          errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.messages?.join(", ")}')
            .join("\n");
        state = LoginErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = LoginErrorState(error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = LoginErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = LoginErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      debugPrint('going inside this DioError block bro');
      debugPrint("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = LoginErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        debugPrint('ERROR RESPONSE: $errorResponse');
        debugPrint('Title: $title');
      }
      debugPrint(e.toString());
      state = LoginErrorState(error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future loginWithGoogle(
    BuildContext context,
  ) async {
    try {
      state = GoogleLoginLoadingState();
      final response = await googleSignInObject.login();
      debugPrint("This is the google signin response $response");
      GoogleSignInAccount? googleObject = response;
      if (googleObject != null) {
        debugPrint('Going inside the backEnd api');
        final sendServerGoogleObject =
            await loginRepository.getLoginWithGoogle(body: googleObject);
        debugPrint('Coming outside the backEnd api');
        await userLocalDataSource.persistUser(sendServerGoogleObject);

        ///Send to dual login screen
        if (sendServerGoogleObject.userType == UserRole.Both.name) {
          debugPrint('Inside LoginSuccessfulBothUserTypesState');

          state = AuthSuccessfulGoogleLoginBothUserExistInState(
              loginResponseModel: sendServerGoogleObject);
        }

        ///Send to Teacher Screen but check which one
        else if (sendServerGoogleObject.userType == UserRole.Teacher.name) {
          ///Send to Teacher Home Screen Verified
          if (sendServerGoogleObject.isVerified == true) {
            ///update the teacherLocked provider value;
            ref.read(isLockedTeacherProvider.notifier).state = true;
            debugPrint(
                'Inside AuthSuccessfulGoogleTeacherLoginInState Teacher Type ${sendServerGoogleObject.isVerified}should be true');
            state = AuthSuccessfulGoogleTeacherLoginInState(isVerified: true);
          }

          ///Send to Teacher Locked Screen
          else {
            ///update the teacherLocked provider value;
            ref.read(isLockedTeacherProvider.notifier).state = false;
            debugPrint(
                'Inside LoginSuccessful Teacher Type ${sendServerGoogleObject.isVerified} should be false');
            state = AuthSuccessfulGoogleTeacherLoginInState(isVerified: false);
          }
        }

        ///Send to Student Home Screen
        else {
          debugPrint('Inside else block of Success LoginSuccessfulState');
          state = AuthSuccessfulGoogleStudentLoginInState();
        }
      }
    } on UnauthorizedException {
      debugPrint('This is the unauthorized part');

      state = GoogleLoginErrorState(
          // error: e.errorText.toString(), errorType: ErrorType.inline);
          error: ' Invalid credentials',
          errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.messages?.join(", ")}')
            .join("\n");
        state = GoogleLoginErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        debugPrint('going inside this BackendResponseError block bro');

        state = GoogleLoginErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        debugPrint('I guess it should be here');
        state =
            GoogleLoginErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      debugPrint('going inside this NoInternetConnectionException block bro');
      state =
          GoogleLoginErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      debugPrint('going inside this DioError block bro');
      debugPrint("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = GoogleLoginErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        debugPrint('ERROR RESPONSE: $errorResponse');
        debugPrint('Title: $title');
      }
      debugPrint(e.toString());
      state = GoogleLoginErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future signUpWithGoogle(BuildContext context,
      {required String userRole}) async {
    try {
      state = GoogleSignUpLoadingState();

      final response = await googleSignInObject.login();
      debugPrint("This is the google SIGNUP response $response");
      GoogleSignInAccount? googleObject = response;
      if (googleObject != null) {
        final sendServerGoogleObject = await loginRepository.signUpWithGoogle(
            body: googleObject, userRole: userRole);
        debugPrint('Coming outside the backEnd api');
        LoginResponseModel signupToSignIn = LoginResponseModel(
          userId: sendServerGoogleObject.userId,
          email: sendServerGoogleObject.email,
          username: sendServerGoogleObject.username,
          token: sendServerGoogleObject.token,
          userType: sendServerGoogleObject.userType,
          message: sendServerGoogleObject.message,
          isVerified: sendServerGoogleObject.isVerified,
        );
        await userLocalDataSource.persistUser(signupToSignIn);
        debugPrint(
            'This is user persisted in SignUp With google ${await userLocalDataSource.getUser()}');
        state = AuthSuccessfulGoogleSignUpState();
      } else {
        state = GoogleSignUpErrorState(
            error: 'An error occured signing up with google, please try again',
            errorType: ErrorType.inline);
      }
      print(response);
      // return;
    } on UnauthorizedException catch (e) {
      debugPrint('This is the unauthorized part');
      debugPrint('This is the unauthorized part ');
      state = GoogleSignUpErrorState(
          // error: e.errorText.toString(), errorType: ErrorType.inline);
          error: ' Invalid credentials + ${e.toString()}',
          errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.messages?.join(", ")}')
            .join("\n");
        state = GoogleSignUpErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        debugPrint('going inside this BackendResponseError block bro');

        state = GoogleSignUpErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        debugPrint('I guess it should be here');
        state = GoogleSignUpErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      debugPrint('going inside this NoInternetConnectionException block bro');
      state =
          GoogleSignUpErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      debugPrint('going inside this DioError block bro');
      debugPrint("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = GoogleSignUpErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      } else if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        debugPrint('ERROR RESPONSE: $errorResponse');
        debugPrint('Title: $title');
      }
      debugPrint(e.toString());
      state = GoogleSignUpErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future signupStudent(BuildContext context,
      {required String username,
      required String email,
      required String password}) async {
    try {
      state = SignUpStudentLoadingState();
      final response = await loginRepository.getSignupStudentCredentials(
          username: username, email: email, password: password);
      LoginResponseModel signupToSignIn = LoginResponseModel(
          userId: response.userId,
          email: response.email,
          username: response.username,
          token: response.token,
          userType: response.userType,
          message: response.message,
          isVerified: response.isVerified);
      await userLocalDataSource.persistUser(signupToSignIn);
      debugPrint(
          'This is user persisted in SignUp With google ${await userLocalDataSource.getUser()}');
      // LoginResponseModel loginResponseModel = LoginResponseModel(
      //   userId: response.userId,
      //   email: response.email.toString(),
      //   // password: password,
      //   username: username,
      //   token: response.userId.toString(),
      //   userType: response.userType.toString(),
      //   message: response.message.toString(),
      // );

      state = SignupSuccessfulStudentState();
      // debugPrint(response);
      return;
    } on UnauthorizedException catch (e) {
      debugPrint('This is the unauthorized part');
      state = AuthErrorState(error: e.message, errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.messages?.join(", ")}')
            .join("\n");
        state = AuthErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        debugPrint('going inside this BackendResponseError block bro');

        state = AuthErrorState(error: e.message, errorType: ErrorType.inline);
      } else {
        debugPrint('I guess it should be here');
        state = AuthErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      debugPrint('going inside this NoInternetConnectionException block bro');
      state = AuthErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      debugPrint('going inside this DioError block bro');
      debugPrint("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = AuthErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        debugPrint('ERROR RESPONSE: $errorResponse');
        debugPrint('Title: $title');
      }
      debugPrint(e.toString());
      state = AuthErrorState(error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future signupTeacher(BuildContext context,
      {required String username,
      required String email,
      required String password}) async {
    try {
      state = SignUpTeacherLoadingState();
      final response = await loginRepository.getSignupTeacherCredentials(
          username: username, email: email, password: password);
      LoginResponseModel signupToSignIn = LoginResponseModel(
        userId: response.userId,
        email: response.email,
        username: response.username,
        token: response.token,
        userType: response.userType,
        message: response.message,
        isVerified: response.isVerified,
      );

      await userLocalDataSource.persistUser(signupToSignIn);

      ref.read(userVerificationStatusProvider.notifier).state = response.isVerified;
      debugPrint(
          'This is user persisted in signupTeacher ${await userLocalDataSource.getUser()}');

      state = SignupSuccessfulTeacherState();
      debugPrint('-----------------');
      debugPrint('Teacher ID Set for TeacherProfileSignupApi');
      debugPrint('Teacher ID is ${response.userId}');
      ref.read(teacherSignUpIdProvider.notifier).state = response.userId;
      ref.read(teacherSignUpNameProvider.notifier).state = response.username;
      ref.read(teacherSignUpEmailProvider.notifier).state = response.email;

      debugPrint(response.toString());
      // return;
    } on UnauthorizedException catch (e) {
      debugPrint('This is the unauthorized part');
      state = AuthErrorState(error: e.message, errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.messages?.join(", ")}')
            .join("\n");
        state = AuthErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        debugPrint('going inside this BackendResponseError block bro');

        state = AuthErrorState(error: e.message, errorType: ErrorType.inline);
      } else {
        debugPrint('I guess it should be here');
        state = AuthErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      debugPrint('going inside this NoInternetConnectionException block bro');
      state = AuthErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      debugPrint('going inside this DioError block bro');
      debugPrint("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = AuthErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        debugPrint('ERROR RESPONSE: $errorResponse');
        debugPrint('Title: $title');
      }
      debugPrint(e.toString());
      state = AuthErrorState(error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future confirmEmail(
    BuildContext context,
  ) async {
    try {
      state = AuthLoadingState();
      final response = await loginRepository.confirmEmail();
      state = LoginSuccessfulState();
      // print(response);
      return;
    } on UnauthorizedException catch (e) {
      debugPrint('This is the unauthorized part');
      state = AuthErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = AuthErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        debugPrint('going inside this BackendResponseError block bro');

        state = AuthErrorState(error: e.message, errorType: ErrorType.inline);
      } else {
        debugPrint('I guess it should be here');
        state = AuthErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      debugPrint('going inside this NoInternetConnectionException block bro');
      state = AuthErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      debugPrint('going inside this DioError block bro');
      debugPrint("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = AuthErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        debugPrint('ERROR RESPONSE: $errorResponse');
        debugPrint('Title: $title');
      }
      debugPrint(e.toString());
      state = AuthErrorState(error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future forgotPassword(BuildContext context, {required String email}) async {
    try {
      state = ForgotPasswordLoadingState();
      final response = await loginRepository.forgotPassword(email: email);
      ref.read(forgotPasswordProviderResponse).message = response.message;
      if (response.message != 'The email field is required') {
        state = ForgotPasswordSuccessfulState();
      } else {
        state = ForgotPasswordErrorState(
            error: response.message, errorType: ErrorType.unauthorized);
        debugPrint(response.toString());
      }
    } on UnauthorizedException catch (e) {
      debugPrint('This is the unauthorized part');
      state = ForgotPasswordErrorState(
          error: e.message.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        debugPrint("This mght be the full shit ${e.error.toString()}");
        final errorMessages = responseErrors
            .map((error) => error.messages?.join(", ") ?? "")
            .join("\n");
        debugPrint(errorMessages);
        state = ForgotPasswordErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        debugPrint('going inside this BackendResponseError block bro');

        state = ForgotPasswordErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        debugPrint('I guess it should be here');
        state = ForgotPasswordErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      debugPrint('going inside this NoInternetConnectionException block bro');
      state = ForgotPasswordErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      debugPrint('going inside this DioError block bro');
      debugPrint("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = ForgotPasswordErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        debugPrint('ERROR RESPONSE: $errorResponse');
        debugPrint('Title: $title');
      }
      debugPrint(e.toString());
      state = ForgotPasswordErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future otpVerificationForgotPassowrd(BuildContext context,
      {required String email, required String code}) async {
    try {
      state = OTPVerificationLoadingState();
      final response =
          await loginRepository.otpVerification(email: email, code: code);
      if (response.message == 'Otp verified!') {
        state = OTPVerificationSuccessfulState();
      } else {
        state = OTPVerificationErrorState(
            error: response.message.toString(), errorType: ErrorType.other);
      }
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = OTPVerificationErrorState(
          error: e.message.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = OTPVerificationErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = OTPVerificationErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = OTPVerificationErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = OTPVerificationErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      debugPrint('going inside this DioError block bro');
      debugPrint("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = OTPVerificationErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        debugPrint('ERROR RESPONSE: $errorResponse');
        debugPrint('Title: $title');
      }
      debugPrint(e.toString());
      state = OTPVerificationErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future otpVerificationStudent(BuildContext context,
      {required String email, required String code}) async {
    try {
      state = OTPEmailVerificationStudentLoadingState();
      final response =
          await loginRepository.otpVerification(email: email, code: code);
      print("this is the response from backend $response");
      if (response.message == 'Otp verified!') {
        state = OTPVerificationStudentSuccessfulState();
      } else {
        state = OTPVerificationStudentErrorState(
            error: response.message.toString(), errorType: ErrorType.other);
      }
    } on UnauthorizedException catch (e) {
      debugPrint('This is the unauthorized part');
      state = OTPVerificationStudentErrorState(
          error: e.message.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = OTPVerificationStudentErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        debugPrint('going inside this BackendResponseError block bro');

        state = OTPVerificationStudentErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        debugPrint('I guess it should be here');
        state = OTPVerificationStudentErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      debugPrint('going inside this NoInternetConnectionException block bro');
      state = OTPVerificationStudentErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      debugPrint('going inside this DioError block bro');
      debugPrint("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = OTPVerificationStudentErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        debugPrint('ERROR RESPONSE: $errorResponse');
        debugPrint('Title: $title');
      }
      debugPrint(e.toString());
      state = OTPVerificationStudentErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future otpVerificationTeacher(BuildContext context,
      {required String email, required String code}) async {
    try {
      state = OTPEmailVerificationTeacherLoadingState();
      final response =
          await loginRepository.otpVerification(email: email, code: code);

      if (response.message == 'Otp verified!') {
        state = OTPVerificationTeacherSuccessfulState();
      } else {
        state = OTPVerificationTeacherErrorState(
            error: response.message.toString(), errorType: ErrorType.other);
      }
    } on UnauthorizedException catch (e) {
      debugPrint('This is the unauthorized part');
      state = OTPVerificationTeacherErrorState(
          error: e.message.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = OTPVerificationTeacherErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        debugPrint('going inside this BackendResponseError block bro');

        state = OTPVerificationTeacherErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        debugPrint('I guess it should be here');
        state = OTPVerificationTeacherErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      debugPrint('going inside this NoInternetConnectionException block bro');
      state = OTPVerificationTeacherErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      debugPrint('going inside this DioError block bro');
      debugPrint("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = OTPVerificationTeacherErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        debugPrint('ERROR RESPONSE: $errorResponse');
        debugPrint('Title: $title');
      }
      debugPrint(e.toString());
      state = OTPVerificationTeacherErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }



  Future resendOtp(BuildContext context, {required String email}) async {
    try {
      state = ResendOtpLoadingState();
      final response = await loginRepository.resendOtp(email: email);
      state = ResendOtpSuccessfulState();
      if (response.message == 'Check Email. Otp Sent Successfully.') {
        state = ResendOtpSuccessfulState();


      } else {
        state = ResendOtpErrorState(
            error: response.message, errorType: ErrorType.unauthorized);
        debugPrint(response.toString());
      }
    } on UnauthorizedException catch (e) {
      debugPrint('This is the unauthorized part');
      state = ResendOtpErrorState(
          error: e.message.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        debugPrint("This mght be the full shit ${e.error.toString()}");
        final errorMessages = responseErrors
            .map((error) => error.messages?.join(", ") ?? "")
            .join("\n");
        debugPrint(errorMessages);
        state = ResendOtpErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        debugPrint('going inside this BackendResponseError block bro');

        state = ResendOtpErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        debugPrint('I guess it should be here');
        state = ResendOtpErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      debugPrint('going inside this NoInternetConnectionException block bro');
      state = ResendOtpErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      debugPrint('going inside this DioError block bro');
      debugPrint("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = ResendOtpErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        debugPrint('ERROR RESPONSE: $errorResponse');
        debugPrint('Title: $title');
      }
      debugPrint(e.toString());
      state = ResendOtpErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }


  Future resetPassword(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      state = ResetPasswordLoadingState();
      final response =
          await loginRepository.resetPassword(email: email, password: password);
      state = ResetPasswordSuccessfulState();
      // if (response.message.toString() == 'Your Password has been reset!') {
      //   state = ResetPasswordSuccessfulState();
      // } else {
      //   state = ResetPasswordErrorState(
      //       error: response.message.toString(), errorType: ErrorType.inline);
      // }
    } on UnauthorizedException catch (e) {
      debugPrint('This is the unauthorized part');
      state = ResetPasswordErrorState(
          error: e.message.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = ResetPasswordErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        debugPrint('going inside this BackendResponseError block bro');

        state = ResetPasswordErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        debugPrint('I guess it should be here');
        state = ResetPasswordErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      debugPrint('going inside this NoInternetConnectionException block bro');
      state =
          ResetPasswordErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      debugPrint('going inside this DioError block bro');
      debugPrint("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = ResetPasswordErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        debugPrint('ERROR RESPONSE: $errorResponse');
        debugPrint('Title: $title');
      }
      debugPrint(e.toString());
      state = ResetPasswordErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future getChronicList(BuildContext context) async {
    if (ref.watch(chronicConditionResponseListProvider).isNotEmpty) {
      return;
    }
    try {
      state = ChronicalLoadingState();
      final response = await chronicRepository.getChronicConditionList();
      state = ChronicSuccessfulState(chronicResponseList: response);
      debugPrint(
          "Chronic List Data Provider ${response[0].chronicConditionName}");
      var list =
          ref.read(chronicConditionResponseListProvider).addAll(response);
      debugPrint(ref
          .read(chronicConditionResponseListProvider)[0]
          .chronicConditionName);
      return response;
    } on UnauthorizedException catch (e) {
      debugPrint('This is the unauthorized part');
      state = AuthErrorState(error: e.message, errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = AuthErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        debugPrint('going inside this BackendResponseError block bro');

        state = AuthErrorState(error: e.message, errorType: ErrorType.inline);
      } else {
        debugPrint('I guess it should be here');
        state = AuthErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      debugPrint('going inside this NoInternetConnectionException block bro');
      state = AuthErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      debugPrint('going inside this DioError block bro');
      debugPrint("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = AuthErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        debugPrint('ERROR RESPONSE: $errorResponse');
        debugPrint('Title: $title');
      }
      debugPrint(e.toString());
      state = AuthErrorState(error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future getPhysicalList(BuildContext context) async {
    if (ref.watch(physicalConditionResponseListProvider).isNotEmpty) {
      return;
    }
    try {
      state = PhysicaLoadingState();

      final response = await physicalRepository.getPhyscialConditionList();
      state = PhysicalSuccessfulState(physicalResponseList: response);
      debugPrint("Physial List Data Provider ${response[0].injuryName}");
      var list =
          ref.read(physicalConditionResponseListProvider).addAll(response);
      debugPrint(ref.read(physicalConditionResponseListProvider)[0].injuryName);
      return response;
    } on UnauthorizedException catch (e) {
      debugPrint('This is the unauthorized part');
      state = AuthErrorState(error: e.errorText, errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = AuthErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        debugPrint('going inside this BackendResponseError block bro');

        state = AuthErrorState(error: e.message, errorType: ErrorType.inline);
      } else {
        debugPrint('I guess it should be here');
        state = AuthErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      debugPrint('going inside this NoInternetConnectionException block bro');
      state = AuthErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      debugPrint('going inside this DioError block bro');
      debugPrint("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = AuthErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        debugPrint('ERROR RESPONSE: $errorResponse');
        debugPrint('Title: $title');
      }
      debugPrint(e.toString());
      state = AuthErrorState(error: e.toString(), errorType: ErrorType.other);
    } on PlatformException catch (e) {
      debugPrint('Platform Exception Occured ${'${e.message!},${e.code}'}');
      state = AuthErrorState(
          error: e.message.toString(), errorType: ErrorType.other);
    } catch (e) {
      debugPrint('Some Weird Exception Occured ${e.toString()}');
      state = AuthErrorState(error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future postStudentProfile() async {
    final userType = ref.read(userTypeProvider.notifier).state.userType.name;
    final userIntention =
        ref.read(userIntentionProvider.notifier).state.userIntention.name;
    final userOtherChroninal = ref.read(chronicOtherConditionProvider);
    final userOtherPhysical = ref.read(physcialOtherConditionProvider);
    final userChronicalList = ref.watch(chronicConditionRequestProvider);
    // final userPhysicalList = ref.read(physicalConditionRequestProvider);
    final usertrauma = ref.read(traumaConditionProvider);
    final userHasSurgery = ref.read(userHasSurgeryProvider);

    final userModel = await userLocalDataSource.getUser();

    debugPrint("====STEP1: USER LEVEL====== $userType");
    debugPrint("====STEP2: USER INTENTION====== $userIntention");
    debugPrint("====STEP5: USER CHRONICAL LIST====== $userChronicalList");
    debugPrint("====STEP4: USER TRAUMA====== $userChronicalList");
    debugPrint(
        "====STEP4: USER SURGERY====== ${userHasSurgery.hasSurgery.name}");

    print("USER ID === ===== ==== ${userModel!.userId}");

    StudentDetailRequest data = StudentDetailRequest(

      userId: userModel.userId,
      //userLocalDataSource.getUser() as int,
      userIntentions: userIntention,
      userLevel: userType,
      userChronicalCondition: userChronicalList,
      userPhysicalCondition: [],
      haveInjury: userHasSurgery.hasSurgery.name == "Yes" ? "Yes" : "No",
      genderId: "Male",
      trauma: usertrauma,
      phoneNum: "",
      occupation: "",
      country: "",
      city: "",
      dob: "",
      placeOfBirth: "",
      chronicalOthers: userOtherChroninal,
      physicalOthers: userOtherPhysical,
    );

    try {
      state = ProflingStudentLoadingState();

      final response = await loginRepository.submitStudentDetails(
          studentDetailRequest: data);

      var userObject = await userLocalDataSource.getUser();
      var deviceToken = await userLocalDataSource.getFCMDeviceToken();

      final sendFcmDeviceToken = await loginRepository.registerDeviceToken(
        deviceTokenRequestModel: DeviceTokenRequestModel(
            userId: userObject!.userId, deviceToken: deviceToken),
      );
      if (sendFcmDeviceToken.message == 'Success!') {
        debugPrint(
            'The token for Student got saved in the backEnd successfully, this the msg ${sendFcmDeviceToken.message}');
      }
      debugPrint(response.toString());
      state = ProflingStudentSuccessfulState();

      //return;
    } on UnauthorizedException catch (e) {
      debugPrint('This is the unauthorized part');
      state = AuthErrorState(
          error: e.message.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.messages?.join(", ")}')
            .join("\n");
        state = AuthErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        debugPrint('going inside this BackendResponseError block bro');

        state = AuthErrorState(error: e.message, errorType: ErrorType.inline);
      } else {
        debugPrint('I guess it should be here');
        state = AuthErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      debugPrint('going inside this NoInternetConnectionException block bro');
      state = AuthErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      debugPrint('going inside this DioError block bro');
      debugPrint("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = AuthErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        debugPrint('ERROR RESPONSE: $errorResponse');
        debugPrint('Title: $title');
      }
      debugPrint(e.toString());
      state = AuthErrorState(error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future<void> postTeacherDetailInfo({required bool isGoogle}) async {
    // final dio = Dio();
    //final url = 'https://ec2-3-7-254-229.ap-south-1.compute.amazonaws.com/api/TeacherDetailInfo';
    // const url = '${Urls.baseUrlDev}/TeacherDetailInfo';

    ///This isthe is google
    print('This is the is google $isGoogle');

    ///If google method called then take the id from the localStoredDB since
    ///Provider is -1
    var getTecherId = await userLocalDataSource.getUser();
    print('This is the teacher id ${getTecherId?.userId.toString()}');

    final formData = FormData.fromMap({
      'DateOfCompletion': ref.read(teacherDocFieldProvider).toString(),
      'Gender': ref.read(teacherGenderFieldProvider),
      'ContactNumber': ref.read(teacherContactFieldProvider),
      'Occupation': ref.read(teacherSpecialtyFieldProvider),
      'City': ref.read(teacherCityFieldProvider),
      'Latitude': 40.785091,
      'Longitude': -73.968285,
      'Headline': ref.read(teacherHeaderLineFieldProvider),
      'Speciality': ref.read(teacherSpecialtyFieldProvider),
      'Institute': ref.read(teacherInstituteFieldProvider),
      'ProfilePicture': await MultipartFile.fromFile(
        ref.read(teacherProfileImagePathProvider.notifier).state,
        filename: ref.read(teacherProfileImageNameProvider.notifier).state,
      ),
      'Country': ref.read(teacherCountryFieldProvider),
      // 'Certification': await MultipartFile.fromFile(
      //     ref.read(teacherCertificateFileNameProvider).state?.path ?? '',
      //     filename: ref.read(teacherCertificateFilePathProvider)?.state ?? ''),
      'Certification': await MultipartFile.fromFile(
          ref.read(teacherCertificateFilePathProvider.notifier).state?.path ??
              '',
          filename:
              ref.read(teacherCertificateFileNameProvider.notifier).state ??
                  ''),

      // await MultipartFile.fromFile(
      //     ref.read(teacherCertificateFilePathProvider),
      //     filename: ref.read(teacherCertificateFileNameProvider)),
      'FullName': ref.read(teacherFullNameFieldProvider),
      'Description': ref.read(teacherHeaderLineFieldProvider),
      'TeacherId': isGoogle
          ? getTecherId?.userId.toString()
          : ref.read(teacherSignUpIdProvider.notifier).state.toString(),

      'YearOfExperience': ref.read(teacherYearsOfExperienceFieldProvider),
      'Age': ref.read(teacherAgeFieldProvider),
    });

    try {
      state = ProflingTeacherLoadingState();
      final response =
          await loginRepository.teacherProfilingDetail(formData: formData);

      ///Save response body in shared preferences for Teacher
      await userLocalDataSource.persistUser(response);
      debugPrint("This is the stored Teacher name ${response.username}");
      debugPrint("This is the stored Teacher email ${response.email}");
      debugPrint("This is the stored Teacher type ${response.userType}");

      ///Remove this if it casues error.
      if (response.message == 'Profile Saved Successfully!') {
        ///Call the FirebaseFCM API and send it back the token alongside the ID.

        ///Dont need to call localDb since the response above has the ID.
        // var userObject = await userLocalDataSource.getUser();
        var deviceToken = await userLocalDataSource.getFCMDeviceToken();

        final sendFcmDeviceToken = await loginRepository.registerDeviceToken(
          deviceTokenRequestModel: DeviceTokenRequestModel(
              userId: response.userId, deviceToken: deviceToken),
        );
        if (sendFcmDeviceToken.message == 'Success!') {
          debugPrint(
              'The token for Teacher got saved in the backEnd successfully, this the msg ${sendFcmDeviceToken.message}');
        }

        ///ID was used because of the screen previously requiring techerID
        /// which we get on signup
        ///Clear the id so it doesn't give any conflicts in the future.
        ref.read(teacherSignUpIdProvider.notifier).dispose();

        ///Clear the Teacheer logged in with google
        ///so it doesn't give any conflicts in the future.
        ref.read(teacherLoggedInWithGoogleProvider.notifier).dispose();

        ///Change status to what we get from the api i.e. false in most cases
        ref.read(isLockedTeacherProvider.notifier).state = response.isVerified;
        debugPrint(
            'This is the new isVerified state now ${ref.read(isLockedTeacherProvider.notifier).state}');
        state = ProflingTeacherSuccessfulState();
      } else {
        state = ProfilingTeacherErrorState(
            error: response.message.toString(), errorType: ErrorType.inline);
      }
    } on UnauthorizedException catch (e) {
      debugPrint('This is the unauthorized part');
      state = ProfilingTeacherErrorState(
          error: e.message.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.field}: ${error.messages?.join(", ")}')
            .join("\n");
        state = ProfilingTeacherErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        debugPrint('going inside this BackendResponseError block bro');

        state = ProfilingTeacherErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        debugPrint('I guess it should be here');
        state = ProfilingTeacherErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      debugPrint('going inside this NoInternetConnectionException block bro');
      state = ProfilingTeacherErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      debugPrint('going inside this DioError block bro');
      debugPrint("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = ProfilingTeacherErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        debugPrint('ERROR RESPONSE: $errorResponse');
        debugPrint('Title: $title');
      }
      debugPrint(e.toString());
      state = ProfilingTeacherErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future<void> logoutUser() async {
    print('Inside logout');
    await userLocalDataSource.deleteUser();
    // ref.read(homeNotifierTeacherProvider.notifier).dispose();
  }
}

final teacherFullNameFieldProvider = StateProvider<String>(
  (ref) => "",
);

final teacherContactFieldProvider = StateProvider<String>(
  (ref) => "",
);

final teacherEmailFieldProvider = StateProvider<String>(
  (ref) => "",
);

final teacherCountryFieldProvider = StateProvider<String>(
  (ref) => "",
);

final teacherCityFieldProvider = StateProvider<String>(
  (ref) => "",
);

final teacherAgeFieldProvider = StateProvider<int>(
  (ref) => 0,
);

// final teacherGenderFieldProvider = StateProvider<UserGenderModel>(
//       (ref) => UserGenderModel(userGender: UserGender.male),
// );

final teacherGenderFieldProvider = StateProvider<String>(
  (ref) => "",
);

final teacherHeaderLineFieldProvider = StateProvider<String>(
  (ref) => "",
);

final teacherProfileImageNameProvider = StateProvider<String>(
  (ref) => "",
);

final teacherProfileImagePathProvider = StateProvider<String>(
  (ref) => "",
);

final teacherSpecialtyFieldProvider = StateProvider<String>(
  (ref) => "",
);

final teacherInstituteFieldProvider = StateProvider<String>(
  (ref) => "",
);

final teacherDocFieldProvider = StateProvider<String>(
  (ref) => "",
);
// StateProvider.autoDispose<DateTime>((ref) => DateTime(1990,05,01),);

final teacherYearsOfExperienceFieldProvider = StateProvider<int>(
  (ref) => 0,
);

final teacherCertificateFileNameProvider = StateProvider<String>(
  (ref) => "",
);

final teacherCertificateFilePathProvider = StateProvider<File?>(
  (ref) => null,
);

final userRoleProvider = StateProvider<UserRoleModel>(
  (ref) => UserRoleModel(userRole: UserRole.None),
);

final userTypeProvider =
    StateProvider<UserLevel>((ref) => UserLevel(userType: UserType.Beginner));

final userIntentionProvider = StateProvider<UserIntentionModel>(
    (ref) => UserIntentionModel(userIntention: UserIntention.Physical));

final userHasSurgeryProvider = StateProvider<HasSurgeryModel>(
    (ref) => HasSurgeryModel(hasSurgery: HasSurgery.No));

final chronicConditionRequestProvider = StateProvider<List<String>>((ref) {
  return [];
});

/*
class ChronicConditionRequestController extends StateNotifier<List<ChronicResponseModel>> {
  ChronicConditionRequestController() : super([]);




  void addItem(ChronicResponseModel item) {
    // Check if the item is already added
    if (state.any((existingItem) => existingItem.chronicConditionId == item.chronicConditionId)) {
      return; // Item already exists, do nothing
    }

    state = [...state, item]; // Add the item to the list
  }

  void removeItem(ChronicResponseModel item) {
    state = state.where((existingItem) => existingItem.chronicConditionId != item.chronicConditionId).toList();
  }

}

final chronicConditionRequestProvider = StateNotifierProvider<ChronicConditionRequestController,List<ChronicResponseModel>>((ref) {
  return ChronicConditionRequestController();
});
*/

final userVerifyProvider = StateProvider<bool>((ref) {
  return false;
});

final teacherSignUpIdProvider = StateProvider<int>((ref) {
  return -1;
});

final teacherSignUpNameProvider = StateProvider<String>((ref) {
  return "";
});

final teacherSignUpEmailProvider = StateProvider<String>((ref) {
  return "";
});

final chronicConditionResponseListProvider =
    Provider<List<ChronicResponseModel>>((ref) {
  return [];
});

final chronicOtherConditionProvider = StateProvider<String>((ref) {
  return "";
});

final physcialOtherConditionProvider = StateProvider<String>((ref) {
  return "";
});

final traumaConditionProvider = StateProvider<String>((ref) {
  return '';
});

final physicalConditionProvider = StateProvider<List<StudentConditions>>((ref) {
  return physicalConditionsList;
});

final physicalConditionRequestProvider =
    StateProvider<List<PhysicalResponseModel>>((ref) {
  return [];
});

final physicalConditionResponseListProvider =
    StateProvider<List<PhysicalResponseModel>>((ref) {
  return [];
});

final agreeTermsProvider = StateProvider<bool>((ref) {
  return false;
});

final teacherLoggedInWithGoogleProvider = StateProvider<bool>((ref) {
  return false;
});

final forgotPasswordProviderResponse =
    Provider<ForgotPasswordResponseModel>((ref) {
  return ForgotPasswordResponseModel(message: '');
});

final teacherProfileStatusProvider = StateProvider<TeacherProfileStatus>(
  (ref) => TeacherProfileStatus(status: ProfileCompletion.Incomplete),
);
