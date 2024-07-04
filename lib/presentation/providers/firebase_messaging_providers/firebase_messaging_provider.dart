import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/network/error_handler_interceptor.dart';
import 'package:moss_yoga/data/repositories/firebase_messaging_repository.dart';
import 'package:moss_yoga/presentation/providers/firebase_messaging_providers/states/firebase_messaging_states.dart';
import 'package:moss_yoga/presentation/providers/screen_state.dart';

final firebaseMessagingNotifierProvider = StateNotifierProvider<
    FirebaseMessagingNotifier, MyCustomFirebaseMessagingStates>(
  (ref) => FirebaseMessagingNotifier(
    ref: ref,
    firebaseMessagingRepository: GetIt.I<FirebaseMessagingRepository>(),
  ),
);

class FirebaseMessagingNotifier
    extends StateNotifier<MyCustomFirebaseMessagingStates> {
  FirebaseMessagingNotifier(
      {required this.ref, required this.firebaseMessagingRepository})
      : super(MyCustomFirebaseMessagingInitialState());

  final Ref ref;
  final FirebaseMessagingRepository firebaseMessagingRepository;

  Future saveTokenOnBackEnd() async {
    try {
      state = MyCustomFirebaseMessagingLoadingState();
      final response = await firebaseMessagingRepository.saveTokenOnBackEnd();
      state = MyCustomFirebaseMessagingSuccessfulState();
      print(response);
      return;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = MyCustomFirebaseMessagingErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.messages?.join(", ")}')
            .join("\n");
        state = MyCustomFirebaseMessagingErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = MyCustomFirebaseMessagingErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = MyCustomFirebaseMessagingErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = MyCustomFirebaseMessagingErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = MyCustomFirebaseMessagingErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = MyCustomFirebaseMessagingErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future saveTokenOnSharedPrefs({required String token}) async {
    try {
      state = MyCustomFirebaseMessagingLoadingState();
      final response = await firebaseMessagingRepository.saveTokenOnSharedPrefs(
          token: token);
      state = MyCustomFirebaseMessagingSuccessfulState();
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = MyCustomFirebaseMessagingErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.messages?.join(", ")}')
            .join("\n");
        state = MyCustomFirebaseMessagingErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = MyCustomFirebaseMessagingErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = MyCustomFirebaseMessagingErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = MyCustomFirebaseMessagingErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = MyCustomFirebaseMessagingErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = MyCustomFirebaseMessagingErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }
}
