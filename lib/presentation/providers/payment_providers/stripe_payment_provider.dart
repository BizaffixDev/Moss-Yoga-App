import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:moss_yoga/data/data_sources/user_local_data_source.dart';
import 'package:moss_yoga/data/models/payment_id_request_model.dart';
import 'package:moss_yoga/data/models/payment_request_model.dart';
import 'package:moss_yoga/data/repositories/payment_data_repository.dart';
import 'package:moss_yoga/presentation/providers/home_provider.dart';
import 'package:moss_yoga/presentation/providers/screen_state.dart';
import 'package:moss_yoga/presentation/screens/payment_methods/states/payment_states.dart';
import '../../../data/network/error_handler_interceptor.dart';

final paymentNotifierProvider =
    StateNotifierProvider<PaymentNotifier, StripeStates>(
  (ref) => PaymentNotifier(
    ref: ref,
    paymentDataRepository: GetIt.I<PaymentDataRepository>(),
    userLocalDataSource: GetIt.I<UserLocalDataSource>(),
  ),
);

class PaymentNotifier extends StateNotifier<StripeStates> {
  PaymentNotifier({
    required this.ref,
    required this.paymentDataRepository,
    required this.userLocalDataSource,
  }) : super(StripeInitialState());

  final Ref ref;
  final PaymentDataRepository paymentDataRepository;
  final UserLocalDataSource userLocalDataSource;

  Future createPaymentIntent(
      {required int teacherId,
      required PaymentIntentModelRequest paymentIntentModelRequest}) async {
    try {
      state = StripeLoadingState();
      // Step 1: Create Payment Intent
      final response = await paymentDataRepository.createPaymentIntent(
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
      // if (paymentResult == null) {
      // Either the payment was successful or the user canceled.
      // To confirm, check with your backend.

      var user = await userLocalDataSource.getUser();
      print(
          'the booking date sent is ${ref.read(selectedDatePreBookingProvider.notifier).state.toString()} ');
      print(
          'the teacherSchedulingDetailCode  sent is ${ref.read(selectedDurationTeacherCodeProvider.notifier).state} ');
      print('yess $paymentResult is null');
      var date = formatSelectedDate(
          ref.read(selectedDatePreBookingProvider.notifier).state);
      print("This is the date inside provider $date");
      PaymentIdRequestModel paymentIdRequestModel = PaymentIdRequestModel(
        paymentIntentId: response.paymentIntentId,
        studentId: user!.userId,
        teacherId: teacherId,
        paymentType: 2,
        description:
            "The student id ${user.userId} wants to book a payment type 2 with teacher named $teacherId ",
        teacherSchedulingDetailCode:
            ref.read(selectedDurationTeacherCodeProvider.notifier).state,
        bookingDate: date,
        // bookingCode: '',
      );
      final paymentStatus = await paymentDataRepository.capturePayment(
          paymentIdRequestModel: paymentIdRequestModel);

      if (paymentStatus.message == 'Payment Succeded for a Pre-Bokking') {
        print('yess $paymentResult is Payment Succeded for a Pre-Bokking?');
        state = StripeSuccessfulState(
          paymentStatus: paymentStatus.message.toString(),
          amount: paymentIntentModelRequest.amount.toString(),
        );
        // Payment was successful
      } else {
        print('ERROR Else block $paymentStatus is NOT succeeded?');
        await Future.delayed(Duration(microseconds: 10));
        state = StripeErrorState(
            error: paymentStatus.message.toString(),
            errorType: ErrorType.inline);
        // Payment was not successful or was canceled by the user
      }
      // }
    } on UnauthorizedException catch (e) {
      debugPrint('This is the unauthorized part ${e.toString()}');
      state = StripeErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.messages?.join(", ")}')
            .join("\n");
        state = StripeErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = StripeErrorState(error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = StripeErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = StripeErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = StripeErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = StripeErrorState(error: e.toString(), errorType: ErrorType.other);
    }

    ///For Stripe Failure
    on StripeException catch (err) {
      print('this the error for stripe ${err}');
      state = StripeErrorState(
          error: err.error.localizedMessage.toString(),
          errorType: ErrorType.other);
    }
  }

  String formatSelectedDate(DateTime selectedDate) {
    print(
        'Date before format ${ref.read(selectedDateProvider.notifier).state}');
    final formattedDate = DateFormat('dd MMMM, yyyy').format(selectedDate);
    return formattedDate;
  }
}
