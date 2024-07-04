import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/models/capture_payment_response_model.dart';
import 'package:moss_yoga/data/models/on_demand_booking_student_response_model.dart';
import 'package:moss_yoga/data/models/on_demand_online_teachers_response_model.dart';
import 'package:moss_yoga/data/models/on_dmand_booking_student_request_model.dart';
import 'package:moss_yoga/data/models/payment_id_request_model.dart';
import 'package:moss_yoga/data/models/payment_intent_response_model.dart';
import 'package:moss_yoga/data/models/payment_request_model.dart';
import 'package:moss_yoga/data/models/teacher_book_session_request_student_model.dart';
import 'package:moss_yoga/data/models/teacher_book_session_response_student_model.dart';

import '../data_sources/user_local_data_source.dart';
import '../models/yoga_styles_response_model.dart';
import '../network/end_points.dart';
import '../network/rest_api_client.dart';

abstract class OnDemandStudentDataSource {
  Future<List<OnDemandOnlineTeacherResponse>> getOnDemandOnlineTeachers();

  Future<List<YogaStylesResponseModel>> getYogaStylesFilter();

  Future<OnDemandBookingStudentResponseModel> bookSession(
      {required OnDemandStudentBookingRequest onDemandStudentBookingRequest});

  Future<TeacherBookSessionResponseStudentModel> teacherResponseToBookSession(
      {required TeacherBookSessionRequestStudentModel
          onDemandStudentBookingRequest});

  Future<List<OnDemandOnlineTeacherResponse>>
      getOnDemandOnlineTeachersBySearch({
    required String gender,
    required String occupation,
    required String name,
    required String city,
    required String minPrice,
    required String maxPrice,
    required String badgeName,
    required String startTime,
  });

  Future<PaymentIntentResponseModel> createPaymentIntent(
      {required PaymentIntentModelRequest paymentIntentModelRequest});

  Future<CapturePaymentResponseModel> capturePayment(
      {required PaymentIdRequestModel paymentIdRequestModel});
}

class OnDemandStudentDataSourceImpl implements OnDemandStudentDataSource {
  OnDemandStudentDataSourceImpl()
      : _restClient = GetIt.instance<ApiService>(),
        _userLocalDataSource = GetIt.instance<UserLocalDataSource>();

  final ApiService _restClient;
  final UserLocalDataSource _userLocalDataSource;

  @override
  Future<List<OnDemandOnlineTeacherResponse>>
      getOnDemandOnlineTeachers() async {
    final result = await _restClient.get(
      Endpoints.onDemandOnlineTeachers,
      queryParameters: {},
    );
    print('This is the result of Poses List $result');
    final response =
        onDemandOnlineTeacherResponseFromJson(json.encode(result.data));
    print('This is the response of decoded List $response');
    return response;
  }

  @override
  Future<List<YogaStylesResponseModel>> getYogaStylesFilter() async {
    final result = await _restClient.get(
      Endpoints.getAllYogaStyles,
      queryParameters: {},
    );
    print('This is the result of yoga List $result');
    final response = YogaStylesListModel.fromJson(result.data);
    print('This is the response of decoded List ${response.styles}');
    return response.styles;
  }

  @override
  Future<OnDemandBookingStudentResponseModel> bookSession(
      {required OnDemandStudentBookingRequest
          onDemandStudentBookingRequest}) async {
    final result = await _restClient.post(
      Endpoints.onDemandStudentBooking,
      onDemandStudentBookingRequest,
    );

    debugPrint('This is the result $result');

    debugPrint(
        'Student My Classes Request====== $onDemandStudentBookingRequest');
    debugPrint(
        'BOOKING CODE ========  ${onDemandStudentBookingRequest.teacherSchedulingDetailCode}');
    if (result.data == null) {
      throw Exception('Empty response');
    }
    final response = OnDemandBookingStudentResponseModel.fromJson(result.data);
    debugPrint('This is the response $response');
    return response;
  }

  @override
  Future<List<OnDemandOnlineTeacherResponse>>
      getOnDemandOnlineTeachersBySearch({
    String? gender,
    String? occupation,
    String? name,
    String? city,
    String? minPrice,
    String? maxPrice,
    String? badgeName,
    String? startTime,
  }) async {
    final result = await _restClient.get(
      Endpoints.onDemandOnlineTeachersBySearch,
      queryParameters: {
        "Gender": gender ?? '',
        "Occupation": occupation ?? '',
        "Name": name ?? '',
        "City": city ?? '',
        "MinRating": minPrice ?? '',
        "MaxRating": maxPrice ?? '',
        "BadgeName": badgeName ?? '',
        "StartTime": startTime ?? '',
      },
    );
    print('This is the result of Poses List $result');
    final response =
        onDemandOnlineTeacherResponseFromJson(json.encode(result.data));
    print('This is the response of decoded List $response');
    return response;
  }

  @override
  Future<PaymentIntentResponseModel> createPaymentIntent(
      {required PaymentIntentModelRequest paymentIntentModelRequest}) async {
    // var headers = {
    //   'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
    // };

    // var testSubject = {
    //   "clientSecret":
    //       "pi_3Ne2nGC4SpUmTFv81iOWC5pV_secret_ac1Q6dFA5YeqfGxDmXrgzgH77"
    // };
    print('this is the request body ${paymentIntentModelRequest.description}');
    print('this is the request body ${paymentIntentModelRequest.currency}');
    print('this is the request body ${paymentIntentModelRequest.amount}');
    final response = await _restClient.post(
      // "${Endpoints.paymentIntent}?amount=${paymentIntentModelRequest.amount}&currency=${paymentIntentModelRequest.currency}&description=${paymentIntentModelRequest.description}",
      Endpoints.paymentIntent,
      paymentIntentModelRequest,
    );
    var result = PaymentIntentResponseModel.fromJson(response.data);
    print("this is the result from payment intent ${result.clientSecret}");
    return result;
  }

  @override
  Future<CapturePaymentResponseModel> capturePayment(
      {required PaymentIdRequestModel paymentIdRequestModel}) async {
    print(
        'this is the request body for ondemand student requested ${paymentIdRequestModel.paymentIntentId} ${paymentIdRequestModel.description}');

    final response = await _restClient.post(
      // "${Endpoints.capturePayment}?paymentIntentId=${paymentIdRequestModel.paymentIntentId}",
      Endpoints.capturePayment,
      paymentIdRequestModel,
    );
    var result = CapturePaymentResponseModel.fromJson(response.data);
    print("this is the result from payment intent ${result.message}");
    return result;
  }

  @override
  Future<TeacherBookSessionResponseStudentModel> teacherResponseToBookSession(
      {required TeacherBookSessionRequestStudentModel
          onDemandStudentBookingRequest}) async {
    // final result = await _restClient.patch("${Endpoints.teacherResponseToBookSession}?bookingCode=${onDemandStudentBookingRequest.bookingCode}", '');
    ///THIS IS FOR DB REASONS I'M SENDING STATIC Uncomment above for proper
    final result = await _restClient.patch(
        "${Endpoints.teacherResponseToBookSession}?bookingCode=BOOK001", '');
    final response =
        TeacherBookSessionResponseStudentModel.fromJson(result.data);
    debugPrint('This is the response $response');
    // final response = TeacherBookSessionResponseStudentModel(
    //     booking: 'Booking: TSD0001 is accepted by teacher');
    return response;
  }
}
