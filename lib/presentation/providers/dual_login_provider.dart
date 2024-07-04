import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/data_sources/user_local_data_source.dart';
import 'package:moss_yoga/data/models/dual_login_user.dart';
import 'package:moss_yoga/data/repositories/dual_login_repository.dart';
import 'package:moss_yoga/presentation/providers/app_providers.dart';
import 'package:moss_yoga/presentation/providers/screen_state.dart';
import 'package:moss_yoga/presentation/screens/auth/both_roles_exist/states/dual_login_states.dart';
import '../../data/network/error_handler_interceptor.dart';

final dualLoginNotifierProvider =
    StateNotifierProvider<DualLoginNotifier, DualLoginStates>(
  (ref) => DualLoginNotifier(
    ref: ref,
    dualLoginRepository: GetIt.I<DualLoginRepository>(),
    userLocalDataSource: GetIt.I<UserLocalDataSource>(),
  ),
);

class DualLoginNotifier extends StateNotifier<DualLoginStates> {
  DualLoginNotifier({
    required this.ref,
    required this.dualLoginRepository,
    required this.userLocalDataSource,
  }) : super(DualLoginInitialState());

  final Ref ref;
  final DualLoginRepository dualLoginRepository;
  final UserLocalDataSource userLocalDataSource;

  Future loginWithOneRole({required DualLoginUser dualLoginUser}) async {
    try {
      state = DualLoginLoadingState();
      final response = await dualLoginRepository.loginWithOneRole(
          dualLoginUser: dualLoginUser);

      ///Save the user object
      await userLocalDataSource.persistUser(response);

      ///Delete this after testing
      var user = await userLocalDataSource.getUser();
      print("this is the user object being saved $user");
      debugPrint("This is the userType sir ${response.userType}");

      /// if Teacher is VERIFIED.
      if (response.isVerified == true && response.userType == 'Teacher') {
        ref.read(isLockedTeacherProvider.notifier).state = true;
        state =
            DualLoginSuccessfulStateTeacher(isVerified: response.isVerified);
      }

      /// if Teacher is NOT VERIFIED.
      else if (response.isVerified == false && response.userType == 'Teacher') {
        ref.read(isLockedTeacherProvider.notifier).state = false;
        state = DualLoginSuccessfulStateTeacherNotVerified();
      }

      ///If Student
      else if (response.userType == 'Student') {
        state = DualLoginSuccessfulStateStudent();
      } else {
        // Handle unexpected userType
        // The following is just an example, adapt according to your needs
        state = DualLoginErrorState(
            error: 'Unexpected userType: ${response.userType}',
            errorType: ErrorType.other);
      }
    } on UnauthorizedException catch (e) {
      debugPrint('This is the unauthorized part ${e.toString()}');
      state = DualLoginErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.field}: ${error.messages?.join(", ")}')
            .join("\n");
        state = DualLoginErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state =
            DualLoginErrorState(error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state =
            DualLoginErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = DualLoginErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = DualLoginErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state =
          DualLoginErrorState(error: e.toString(), errorType: ErrorType.other);
    }
  }
}
