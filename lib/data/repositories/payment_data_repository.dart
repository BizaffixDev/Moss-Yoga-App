import 'package:moss_yoga/data/data_sources/dual_login_data_source.dart';
import 'package:moss_yoga/data/data_sources/payment_data_source.dart';
import 'package:moss_yoga/data/models/capture_payment_response_model.dart';
import 'package:moss_yoga/data/models/dual_login_user.dart';
import 'package:moss_yoga/data/models/login_response_model.dart';
import 'package:moss_yoga/data/models/payment_id_request_model.dart';
import 'package:moss_yoga/data/models/payment_intent_response_model.dart';
import 'package:moss_yoga/data/models/payment_request_model.dart';

abstract class PaymentDataRepository {
  Future<PaymentIntentResponseModel> createPaymentIntent(
      {required PaymentIntentModelRequest paymentIntentModelRequest});

  Future<CapturePaymentResponseModel> capturePayment(
      {required PaymentIdRequestModel paymentIdRequestModel});
}

class PaymentDataRepositoryImpl extends PaymentDataRepository {
  PaymentDataRepositoryImpl(this.paymentDataSource);

  final PaymentDataSource paymentDataSource;

  @override
  Future<PaymentIntentResponseModel> createPaymentIntent(
      {required PaymentIntentModelRequest paymentIntentModelRequest}) {
    {
      return paymentDataSource.createPaymentIntent(
          paymentIntentModelRequest: paymentIntentModelRequest);
    }
  }

  @override
  Future<CapturePaymentResponseModel> capturePayment(
      {required PaymentIdRequestModel paymentIdRequestModel}) {
    return paymentDataSource.capturePayment(
        paymentIdRequestModel: paymentIdRequestModel);
  }
}
