import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/models/on_demand_online_teachers_response_model.dart';
import 'package:moss_yoga/data/models/on_dmand_booking_student_request_model.dart';
import 'package:moss_yoga/data/models/payment_id_request_model.dart';
import 'package:moss_yoga/data/models/payment_request_model.dart';
import 'package:moss_yoga/data/models/student_request_to_teacher_response.dart';
import 'package:moss_yoga/data/models/teacher_book_session_request_student_model.dart';
import 'package:moss_yoga/data/repositories/on_demand_student_repository.dart';
import 'package:moss_yoga/presentation/providers/screen_state.dart';

import '../../../data/data_sources/user_local_data_source.dart';
import '../../../data/network/error_handler_interceptor.dart';
import '../../../data/repositories/teacher_repositories/on_demand_teacher_repository.dart';
import '../../screens/teachers_screens/on_demand/on_demand_teacher_states.dart';


final onDemandTeacherNotifierProvider =
StateNotifierProvider<OnDemandTeachertNotifier, OnDemandTeacherStates>(
      (ref) =>
      OnDemandTeachertNotifier(
        ref: ref,
        onDemandTeacherRepository: GetIt.I<OnDemandTeacherRepository>(),
        userLocalDataSource: GetIt.I<UserLocalDataSource>(),
      ),
);

class OnDemandTeachertNotifier extends StateNotifier<OnDemandTeacherStates> {
  OnDemandTeachertNotifier({required this.ref,
    required this.onDemandTeacherRepository,
    required this.userLocalDataSource})
      : super(OnDemandTeacherInitialState());

  final Ref ref;
  final OnDemandTeacherRepository onDemandTeacherRepository;
  final UserLocalDataSource userLocalDataSource;

  Future getStudentRequests({required String teacherId}) async {
    try {
      state = OnDemandTeacherLoadingState();
      print("the getTopRatedTeachers api state is now $state");
      final response =
      await onDemandTeacherRepository.getStudnentRequests(teacherId: teacherId);

      final onDemandRequestNotifier =
      ref.read(onDemandStudentRequestProvider.notifier);
      onDemandRequestNotifier.deleteAllRequests();
      onDemandRequestNotifier.updateRequests(response);

      state = OnDemandTeacherSuccessfulState();
      print(response);
      return;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = OnDemandTeacherErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = OnDemandTeacherErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = OnDemandTeacherErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = OnDemandTeacherErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = OnDemandTeacherErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = OnDemandTeacherErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = OnDemandTeacherErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }




  Future acceptStudentRequest({required String bookingId}) async {
    try {
      state = OnDemandTeacherAcceptLoadingState();
      print("the getTopRatedTeachers api state is now $state");
      final response =
      await onDemandTeacherRepository.acceptStudentRequest(bookingId: bookingId);


      state = OnDemandTeacherAcceptSuccessfulState();
      print(response);
      return;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = OnDemandTeacherAcceptErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = OnDemandTeacherAcceptErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = OnDemandTeacherAcceptErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = OnDemandTeacherAcceptErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = OnDemandTeacherAcceptErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = OnDemandTeacherAcceptErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = OnDemandTeacherAcceptErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }



  Future rejectStudentRequest({required String bookingId}) async {
    try {
      state = OnDemandTeacherRejectLoadingState();
      print("the getTopRatedTeachers api state is now $state");
      final response =
      await onDemandTeacherRepository.rejectStudentRequest(bookingId: bookingId);


      state = OnDemandTeacherRejectSuccessfulState();
      print(response);
      return;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = OnDemandTeacherAcceptErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = OnDemandTeacherRejectErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = OnDemandTeacherRejectErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = OnDemandTeacherRejectErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = OnDemandTeacherRejectErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = OnDemandTeacherRejectErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = OnDemandTeacherRejectErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }












}

final bookingCodeProvider = StateProvider<String>((ref) {
  return '';
});


class OnDemandStudentRequestNotifier
    extends StateNotifier<List<StudentRequestsToTeacherResponse>> {
  OnDemandStudentRequestNotifier() : super([]);

  updateRequests(List<StudentRequestsToTeacherResponse> requests) {
    state = requests;
  }

  deleteAllRequests() {
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

final onDemandStudentRequestProvider = StateNotifierProvider<
    OnDemandStudentRequestNotifier,
    List<StudentRequestsToTeacherResponse>>(
      (ref) => OnDemandStudentRequestNotifier(),
);




