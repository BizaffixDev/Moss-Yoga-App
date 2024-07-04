import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/models/capture_payment_response_model.dart';
import 'package:moss_yoga/data/models/payment_id_request_model.dart';
import 'package:moss_yoga/data/models/payment_intent_response_model.dart';
import 'package:moss_yoga/data/models/payment_request_model.dart';
import 'package:moss_yoga/data/network/end_points.dart';
import 'package:moss_yoga/data/network/rest_api_client.dart';

abstract class PaymentDataSource {
  Future<PaymentIntentResponseModel> createPaymentIntent(
      {required PaymentIntentModelRequest paymentIntentModelRequest});

  Future<CapturePaymentResponseModel> capturePayment(
      {required PaymentIdRequestModel paymentIdRequestModel});
}

class PaymentDataSourceImpl extends PaymentDataSource {
  PaymentDataSourceImpl() : _restClient = GetIt.instance<ApiService>();

  final ApiService _restClient;

  final String baseUrl = 'YOUR_BACKEND_URL';

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
        'this is the date being sent for capture payment body ${paymentIdRequestModel.bookingDate}');

    final response = await _restClient.post(
      "${Endpoints.capturePayment}?paymentIntentId=${paymentIdRequestModel.paymentIntentId}",
      paymentIdRequestModel,
    );
    var result = CapturePaymentResponseModel.fromJson(response.data);
    print("this is the result from capturePayment ${result.message}");
    return result;
  }
}
