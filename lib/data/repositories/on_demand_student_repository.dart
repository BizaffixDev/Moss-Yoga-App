import 'package:moss_yoga/data/models/capture_payment_response_model.dart';
import 'package:moss_yoga/data/models/payment_id_request_model.dart';
import 'package:moss_yoga/data/models/payment_intent_response_model.dart';
import 'package:moss_yoga/data/models/payment_request_model.dart';
import 'package:moss_yoga/data/models/teacher_book_session_request_student_model.dart';
import 'package:moss_yoga/data/models/teacher_book_session_response_student_model.dart';
import 'package:moss_yoga/data/models/yoga_styles_response_model.dart';

import '../data_sources/on_demand_student_data_source.dart';
import '../models/on_demand_booking_student_response_model.dart';
import '../models/on_demand_online_teachers_response_model.dart';
import '../models/on_dmand_booking_student_request_model.dart';

abstract class OnDemandStudentRepository {
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
// Future<GuideResponse> getGuide();
}

class OnDemandStudentRepositoryImpl extends OnDemandStudentRepository {
  OnDemandStudentRepositoryImpl(this.onDemandStudentDataSource);

  final OnDemandStudentDataSource onDemandStudentDataSource;

  @override
  Future<List<OnDemandOnlineTeacherResponse>> getOnDemandOnlineTeachers() {
    return onDemandStudentDataSource.getOnDemandOnlineTeachers();
  }

  @override
  Future<List<YogaStylesResponseModel>> getYogaStylesFilter() {
    return onDemandStudentDataSource.getYogaStylesFilter();
  }

  @override
  Future<OnDemandBookingStudentResponseModel> bookSession(
      {required OnDemandStudentBookingRequest onDemandStudentBookingRequest}) {
    return onDemandStudentDataSource.bookSession(
        onDemandStudentBookingRequest: onDemandStudentBookingRequest);
  }

  @override
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
  }) {
    return onDemandStudentDataSource.getOnDemandOnlineTeachersBySearch(
      gender: gender,
      occupation: occupation,
      name: name,
      city: city,
      minPrice: minPrice,
      maxPrice: maxPrice,
      badgeName: badgeName,
      startTime: startTime,
    );
  }

  @override
  Future<CapturePaymentResponseModel> capturePayment(
      {required PaymentIdRequestModel paymentIdRequestModel}) {
    return onDemandStudentDataSource.capturePayment(
        paymentIdRequestModel: paymentIdRequestModel);
  }

  @override
  Future<PaymentIntentResponseModel> createPaymentIntent(
      {required PaymentIntentModelRequest paymentIntentModelRequest}) {
    return onDemandStudentDataSource.createPaymentIntent(
        paymentIntentModelRequest: paymentIntentModelRequest);
  }

  @override
  Future<TeacherBookSessionResponseStudentModel> teacherResponseToBookSession(
      {required TeacherBookSessionRequestStudentModel
          onDemandStudentBookingRequest}) {
    return onDemandStudentDataSource.teacherResponseToBookSession(
        onDemandStudentBookingRequest: onDemandStudentBookingRequest);
  }

/* @override
  Future<GuideResponse> getGuide() {
    return onDemandStudentDataSource.getGuide();
  }*/
}
