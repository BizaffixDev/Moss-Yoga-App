import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/data_sources/user_local_data_source.dart';
import 'package:moss_yoga/data/models/switch_screen_request_model.dart';
import 'package:moss_yoga/data/repositories/switch_screen_repository.dart';
import 'package:moss_yoga/presentation/providers/dual_login_provider.dart';
import 'package:moss_yoga/presentation/providers/login_provider.dart';
import 'package:moss_yoga/presentation/providers/payment_providers/stripe_payment_provider.dart';
import 'package:moss_yoga/presentation/providers/screen_state.dart';
import 'package:moss_yoga/presentation/providers/student_profiling_provider/student_account_provider.dart';
import 'package:moss_yoga/presentation/screens/switch_screens/states/switch_states.dart';
import '../../data/network/error_handler_interceptor.dart';

final swithcNotifierProvider =
StateNotifierProvider<SwitchScreenNotifier, SwitchScreenStates>(
      (ref) =>
      SwitchScreenNotifier(
        ref: ref,
        switchScreenRepository: GetIt.I<SwitchScreenRepository>(),
        userLocalDataSource: GetIt.I<UserLocalDataSource>(),
      ),
);

class SwitchScreenNotifier extends StateNotifier<SwitchScreenStates> {
  SwitchScreenNotifier({
    required this.ref,
    required this.switchScreenRepository,
    required this.userLocalDataSource,
  }) : super(SwitchScreenInitialState());

  final Ref ref;
  final SwitchScreenRepository switchScreenRepository;
  final UserLocalDataSource userLocalDataSource;

  ///From Student to Teacher
  Future switchToTeacher(
      {required SwitchScreenRequestModel switchScreenRequestModel}) async {
    try {
      state = SwitchScreenLoadingState();
      final response = await switchScreenRepository.switchToTeacher(
          switchScreenRequestModel: switchScreenRequestModel);

      print('HERE-----------------------HERE');
      print(response.username);
      print(response.token);
      print(response.isVerified);
      print(response.username);
      print('-----------------------');
      if (response.message == 'Switched Successfully!') {
        ///Save new Object in LocalStorage
        await userLocalDataSource.deleteUser();

        ///Check if its empty
        var user = await userLocalDataSource.getUser();
        print("This is the user email coming after delete ${user?.email}");

        ///Delete/logout all states and providers
        // ref.read(authNotifyProvider.notifier).dispose();
        // ref.read(paymentNotifierProvider.notifier).dispose();
        // ref.read(studentAccountNotifierProvider.notifier).dispose();
        // ref.read(dualLoginNotifierProvider.notifier).dispose();

        print('Deleted all prev providers');

        ///Saving new object
        await userLocalDataSource.persistUser(response);
        print('New user saveed in local Db');
        var user2 = await userLocalDataSource.getUser();
        print("This is the user email coming after delete ${user2?.email}");
        state = SwitchScreenSuccessfulSendToTeacherState();
      }
      else {
        print("Inside else block of the switch_screen provider layer");
        state = SwitchScreenErrorGoBackStudentState(
            error: response.message, errorType: ErrorType.inline);
      }
    } on UnauthorizedException {
      print('This is the unauthorized part');
      state = SwitchScreenErrorGoBackStudentState(
          error: ' Invalid credentials', errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.messages?.join(", ")}')
            .join("\n");
        state = SwitchScreenErrorGoBackStudentState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = SwitchScreenErrorGoBackStudentState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = SwitchScreenErrorGoBackStudentState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = SwitchScreenErrorGoBackStudentState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = SwitchScreenErrorGoBackStudentState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = SwitchScreenErrorGoBackStudentState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  ///From Teacher To Student
  Future switchToStudent(
      {required SwitchScreenRequestModel switchScreenRequestModel}) async {
    try {
      ///check if 200 response.
      ///IF 200 response then send to new dashboard.
      ///Else send back.
      ///If It's a Teacher going to Student then send either way?
      print('Inside Try and making state loading');
      state = SwitchScreenLoadingState();
      final response = await switchScreenRepository.switchToStudent(
          switchScreenRequestModel: switchScreenRequestModel);
      print('This is the response in switch provider $response');
      print('This is the response message ${response.message}');

      if (response.message == 'Switched Successfully!') {
        ///Save new Object in LocalStorage
        await userLocalDataSource.deleteUser();

        ///Check if its empty
        var user = await userLocalDataSource.getUser();
        print("This is the user email coming after delete ${user?.email}");

        ///Delete/logout all states and providers
        // ref.read(authNotifyProvider.notifier).dispose();
        // ref.read(paymentNotifierProvider.notifier).dispose();
        // ref.read(studentAccountNotifierProvider.notifier).dispose();
        // ref.read(dualLoginNotifierProvider.notifier).dispose();

        print('Deleted all prev providers');

        ///Saving new object
        await userLocalDataSource.persistUser(response);
        print('New user saveed in local Db');
        var user2 = await userLocalDataSource.getUser();
        print("This is the user email coming after delete ${user2?.email}");

        state = SwitchScreenSuccessfulSendToStudentState();
      }
      else {
        print('Inside switch to Student else Block');
        state = SwitchScreenErrorGoBackTeacherState(
            error: response.message, errorType: ErrorType.inline);
      }
    } on UnauthorizedException {
      print('This is the unauthorized part');
      state = SwitchScreenErrorGoBackTeacherState(
          error: ' Invalid credentials', errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.messages?.join(", ")}')
            .join("\n");
        state = SwitchScreenErrorGoBackTeacherState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = SwitchScreenErrorGoBackTeacherState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = SwitchScreenErrorGoBackTeacherState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = SwitchScreenErrorGoBackTeacherState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = SwitchScreenErrorGoBackTeacherState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = SwitchScreenErrorGoBackTeacherState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }
}
