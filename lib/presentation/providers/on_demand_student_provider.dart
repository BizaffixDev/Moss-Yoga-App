import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/models/on_demand_online_teachers_response_model.dart';
import 'package:moss_yoga/data/models/on_dmand_booking_student_request_model.dart';
import 'package:moss_yoga/data/models/payment_id_request_model.dart';
import 'package:moss_yoga/data/models/payment_request_model.dart';
import 'package:moss_yoga/data/models/teacher_book_session_request_student_model.dart';
import 'package:moss_yoga/data/repositories/on_demand_student_repository.dart';
import 'package:moss_yoga/presentation/providers/screen_state.dart';

import '../../data/data_sources/user_local_data_source.dart';
import '../../data/models/login_response_model.dart';
import '../../data/models/yoga_styles_response_model.dart';
import '../../data/network/error_handler_interceptor.dart';
import '../screens/students_screens/on_demand/on_demand_states/on_demand_states.dart';

final onDemandStudentNotifierProvider =
    StateNotifierProvider<OnDemandStudentNotifier, OnDemandStudentStates>(
  (ref) => OnDemandStudentNotifier(
    ref: ref,
    onDemandStudentRepository: GetIt.I<OnDemandStudentRepository>(),
    userLocalDataSource: GetIt.I<UserLocalDataSource>(),
  ),
);

class OnDemandStudentNotifier extends StateNotifier<OnDemandStudentStates> {
  OnDemandStudentNotifier(
      {required this.ref,
      required this.onDemandStudentRepository,
      required this.userLocalDataSource})
      : super(OnDemandStudentInitialState());

  final Ref ref;
  final OnDemandStudentRepository onDemandStudentRepository;
  final UserLocalDataSource userLocalDataSource;

  Future getTopRatedTeachers() async {
    try {
      state = OnDemandStudentLoadingState();
      print("the getTopRatedTeachers api state is now $state");
      final response =
          await onDemandStudentRepository.getOnDemandOnlineTeachers();

      final onDemandTeachersNotifier =
          ref.read(onDemandOnlineTeachersProvider.notifier);
      onDemandTeachersNotifier.deleteAllTeachers();
      onDemandTeachersNotifier.updateTeachers(response);

      state = OnDemandStudentSuccessfulState();
      print(response);
      return;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = OnDemandStudentErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = OnDemandStudentErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = OnDemandStudentErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = OnDemandStudentErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = OnDemandStudentErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = OnDemandStudentErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = OnDemandStudentErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future getYogaStyles() async {
    if (ref.watch(allYogaStylesFilterProvider).isNotEmpty) {
      return;
    }
    try {
      state = OnDemandStudentBookingLoadingState();
      final response = await onDemandStudentRepository.getYogaStylesFilter();
      ref.read(allYogaStylesFilterProvider).addAll(response);

      // print("This is the pose name" + ref.read(allPosesProvider)[0].poseName);
      state = FilterStudentSuccessfulState();
      print(response);
      return;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = FilterStudentErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = FilterStudentErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = FilterStudentErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = FilterStudentErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state =
          FilterStudentErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = FilterStudentErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = FilterStudentErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future bookSession(
      {required String bookingCode, required String date}) async {
    LoginResponseModel? user = await userLocalDataSource.getUser();

    OnDemandStudentBookingRequest data = OnDemandStudentBookingRequest(
      studentId: user!.userId,
      teacherSchedulingDetailCode: bookingCode,
      bookingDate: date,
      paymentId: 0,
    );

    try {
      state = OnDemandStudentBookingLoadingState();
      final response = await onDemandStudentRepository.bookSession(
          onDemandStudentBookingRequest: data);

      state = OnDemandStudentBookingSuccessfulState();

      ref.read(bookingCodeProvider.notifier).state = response.bookingCode;

      print(response);
      print(
          "BOOKING CODE FROM RESPONSE ======   ${ref.read(bookingCodeProvider)} ");
      return;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = OnDemandStudentBookingErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.messages?.join(", ")}')
            .join("\n");
        state = OnDemandStudentBookingErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = OnDemandStudentBookingErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = OnDemandStudentBookingErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = OnDemandStudentBookingErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = OnDemandStudentBookingErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = OnDemandStudentBookingErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  ///Separate loader since this is other screen too.
  ///
  ///Make method that checks if the bookSession has been accepted by Teacher
  /// IF Accepted change state and make the user pay.
  /// IF not show them not accepted.

  Future teacherResponseToBookSession(
      {required TeacherBookSessionRequestStudentModel
          teacherBookSessionRequestStudentModel}) async {
    try {
      state = OnDemandStudentTeacherLoadingState();

      ///Uncomment below and add a model and change the endpoint at data source
      ///and send data from here

      print(
          "This is the code thats being sent ${teacherBookSessionRequestStudentModel.bookingCode}");

      final response =
          await onDemandStudentRepository.teacherResponseToBookSession(
              onDemandStudentBookingRequest:
                  teacherBookSessionRequestStudentModel);
      print("This is the booking response ${response.message}");
      print("This is the booking response ${response.data.teacherId}");

      ///This will be used in the method below for teacher capture payment id
      ref.read(acceptedOnDemandbookingTeacherIdProvider.notifier).state =
          response.data.teacherId;
      // ref.read(bookingCodeProvider.notifier).state = response.booking;
      await Future.delayed(const Duration(seconds: 2));

      ///If its successful, then go here and show payment option.
      ///We need teacher id and payment Id (maybe) as well.
      if (response.message == 'Accepted') {
        print('Inside successful state');
        state = OnDemandStudentTeacherAcceptedRequestState(
            price: response.data.price);
      } else {
        print('Maybe Inside erro state why tho?');

        state = OnDemandStudentBookingErrorState(
            error: response.message.toString(), errorType: ErrorType.inline);
      }
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = OnDemandStudentBookingErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.messages?.join(", ")}')
            .join("\n");
        state = OnDemandStudentBookingErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = OnDemandStudentBookingErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = OnDemandStudentBookingErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = OnDemandStudentBookingErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = OnDemandStudentBookingErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = OnDemandStudentBookingErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future onDemandCreatePaymentIntent(
      {required int teacherId,
      required PaymentIntentModelRequest paymentIntentModelRequest}) async {
    try {
      state = OnDemandStudentTeacherLoadingState();
      // Step 1: Create Payment Intent
      final response = await onDemandStudentRepository.createPaymentIntent(
          paymentIntentModelRequest: paymentIntentModelRequest);
      print(
          'This is the response on Provider Level Stripe: ${response.clientSecret} ');
      // Step 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: response.clientSecret,
          merchantDisplayName: 'Moss Yoga',
        ),
      )
          .then((value) {
        // print('this is the value step 2 : $value');
      });

      // Step 3: Show Payment Sheet
      final PaymentSheetPaymentOption? paymentResult =
          await Stripe.instance.presentPaymentSheet();

      print("before going in the if else statements $paymentResult");

      // Step 4: Verify Payment Status on Backend send the paymentIntentId
      // Either the payment was successful or the user canceled.
      // To confirm, check with backend.
      var user = await userLocalDataSource.getUser();
      print('yess $paymentResult is null');
      PaymentIdRequestModel paymentIdRequestModel =
          // PaymentIdRequestModel(response.paymentIntentId);
          PaymentIdRequestModel(
        paymentIntentId: response.paymentIntentId,
        studentId: user!.userId,
        teacherId: teacherId,
        paymentType: 1,
        description:
            "Payment by userId ${user.userId} to TeacherId $teacherId for ON-Demand",
        teacherSchedulingDetailCode: '',
        bookingDate: '',
        // bookingCode: '',
      );
      print(
          'Payment by userId ${user.userId} to TeacherId $teacherId for ON-Demand');

      final paymentStatus = await onDemandStudentRepository.capturePayment(
          paymentIdRequestModel: paymentIdRequestModel);

      ///API WASNT WORKING Thats why I did this
      // String payTest = 'Succeeded';
      // if (payTest == "Succeeded") {
      //   print('yess $paymentResult is succeeded?');
      //   state = OnDemandStripeSuccessfulState(
      //     paymentStatus: payTest.toString(),
      //     amount: paymentIntentModelRequest.amount.toString(),
      //   );
      // }

      ///UNCOMMENT BELOW TO TEST REAL API RESPONSE

      if (paymentStatus.message == "Payment Succeded for On Demand") {
        print('yess $paymentResult is succeeded?');
        state = OnDemandStripeSuccessfulState(
          paymentStatus: paymentStatus.message.toString(),
          amount: paymentIntentModelRequest.amount.toString(),
        );
      } else {
        // Payment was not successful or was canceled by the user
        print('ERROR Else block $paymentStatus is NOT succeeded?');
        await Future.delayed(Duration(microseconds: 10));
        state = OnDemandStripeErrorState(
            error: paymentStatus.message.toString(),
            errorType: ErrorType.inline);
      }
    } on UnauthorizedException catch (e) {
      debugPrint('This is the unauthorized part ${e.toString()}');
      state = OnDemandStripeErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.messages?.join(", ")}')
            .join("\n");
        state = OnDemandStripeErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = OnDemandStripeErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = OnDemandStripeErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = OnDemandStripeErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = OnDemandStripeErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = OnDemandStripeErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }

    ///For Stripe Failure
    on StripeException catch (err) {
      print('this the error for stripe ${err}');
      state = OnDemandStripeErrorState(
          error: err.error.localizedMessage.toString(),
          errorType: ErrorType.other);
    }
  }

  Future getTopRatedTeachersBySearch({
    String? gender,
    String? occupation,
    String? name,
    String? city,
    String? minPrice,
    String? maxPrice,
    String? badgeName,
    String? startTime,
  }) async {
    try {
      state = OnDemandStudentLoadingState();
      final response =
          await onDemandStudentRepository.getOnDemandOnlineTeachersBySearch(
        gender: gender ?? '',
        occupation: occupation ?? '',
        name: name ?? '',
        city: city ?? '',
        minPrice: minPrice ?? '',
        maxPrice: maxPrice ?? '',
        badgeName: badgeName ?? '',
        startTime: startTime ?? '',
      );

      final onDemandTeachersNotifier =
          ref.read(onDemandOnlineTeachersProvider.notifier);

      // Delete all teachers

      // ref.read(onDemandTeachersProvider).addAll(response);

      Future.delayed(const Duration(milliseconds: 10), () async {
        await onDemandTeachersNotifier.deleteAllTeachers();
        await onDemandTeachersNotifier.updateTeachers(response);
      });

      state = FilterStudentSuccessfulState();
      print(response);
      return;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = OnDemandStudentErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = FilterStudentErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = FilterStudentErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = FilterStudentErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state =
          FilterStudentErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = FilterStudentErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = FilterStudentErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }
}

final bookingCodeProvider = StateProvider<String>((ref) {
  return '';
});

final acceptedOnDemandbookingTeacherIdProvider = StateProvider<int>((ref) {
  return -1;
});

final allYogaStylesFilterProvider =
    Provider<List<YogaStylesResponseModel>>((ref) {
  return [];
});

final allYogaStylesSelectedProvider =
    Provider<List<YogaStylesResponseModel>>((ref) {
  return [];
});

/*final onDemandTeachersProvider =
    Provider<List<OnDemandOnlineTeacherResponse>>((ref) {
  return [];
});*/

class OnDemandOnlineTeachersNotifier
    extends StateNotifier<List<OnDemandOnlineTeacherResponse>> {
  OnDemandOnlineTeachersNotifier() : super([]);

  updateTeachers(List<OnDemandOnlineTeacherResponse> teachers) {
    state = teachers;
  }

  deleteAllTeachers() {
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

final onDemandOnlineTeachersProvider = StateNotifierProvider<
    OnDemandOnlineTeachersNotifier, List<OnDemandOnlineTeacherResponse>>(
  (ref) => OnDemandOnlineTeachersNotifier(),
);

class SavedTeacherNotifier
    extends StateNotifier<List<OnDemandOnlineTeacherResponse>> {
  SavedTeacherNotifier() : super([]);

  void addTeacher(OnDemandOnlineTeacherResponse teacher) {
    state = [...state, teacher];
  }

  void deleteTeacher(int teacherId) {
    state = state.where((teacher) => teacher.teacherId != teacherId).toList();
  }
}

final savedTeacherProvider = StateNotifierProvider<SavedTeacherNotifier,
    List<OnDemandOnlineTeacherResponse>>(
  (ref) => SavedTeacherNotifier(),
);

final genderFilterProvider = Provider<String>((ref) {
  return "";
});

final bookingCode = Provider<String>((ref) {
  return "";
});

final searchTextFilterProvider = Provider<String>((ref) {
  return "";
});

final requestSentProvider = StateProvider<bool>((ref) {
  return false;
});

final teacherNameProvider = StateProvider<String>((ref) {
  return "";
});

final teacherBookingIdProvider = StateProvider<String>((ref) {
  return "";
});

final teacherSpecialityProvider = StateProvider<String>((ref) {
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

final teacherSpecialityListProvider = StateProvider<List<String>>((ref) {
  return [];
});
