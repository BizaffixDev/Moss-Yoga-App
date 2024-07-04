import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/models/faq_response.dart';
import 'package:moss_yoga/data/repositories/help_support_repository.dart';
import 'package:moss_yoga/presentation/providers/screen_state.dart';
import 'package:moss_yoga/presentation/screens/help_and_support/help_support_states.dart';
import '../../../data/network/error_handler_interceptor.dart';
import '../../data/models/help_support_response_model.dart';



final helpSupportNotifierProvider = StateNotifierProvider<
    HelpSupportNotifier, HelpSupportStates>(
      (ref) => HelpSupportNotifier(
    ref: ref,
        helpSupportRepository: GetIt.I<HelpSupportRepository>(),
  ),
);

class HelpSupportNotifier
    extends StateNotifier<HelpSupportStates> {
  HelpSupportNotifier(
      {required this.ref, required this.helpSupportRepository})
      : super(HelpSupportStatesInitialState());

  final Ref ref;
  final HelpSupportRepository helpSupportRepository;



  Future getLearnMossYoga() async {

    try {
      state = LearnMossYogaLoadingState();
      final response = await helpSupportRepository.getLearnMossYogaData();
      ref.read(learnMossYogaProvider.notifier).state = response; // Update the provider state

      state =LearnMossYogaSuccessfulState();
      // debugPrint(response);
      print("HELP SUPPORT RESPONSE ====  $response");
      return;
    } on UnauthorizedException catch (e) {
      debugPrint('This is the unauthorized part');
      state = LearnMossYogaErrorState(error: e.message, errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.messages?.join(", ")}')
            .join("\n");
        state = LearnMossYogaErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        debugPrint('going inside this BackendResponseError block bro');

        state = LearnMossYogaErrorState(error: e.message, errorType: ErrorType.inline);
      } else {
        debugPrint('I guess it should be here');
        state = LearnMossYogaErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      debugPrint('going inside this NoInternetConnectionException block bro');
      state = LearnMossYogaErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      debugPrint('going inside this DioError block bro');
      debugPrint("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = LearnMossYogaErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        debugPrint('ERROR RESPONSE: $errorResponse');
        debugPrint('Title: $title');
      }
      debugPrint(e.toString());
      state = LearnMossYogaErrorState(error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future getFAQs() async {

    try {
      state = FaqLoadingState();
      final response = await helpSupportRepository.getFaqs();
      ref.read(faqsProvider.notifier).state = response; // Update the provider state

      state =FaqSuccessfulState();
      // debugPrint(response);
      print("FAQ RESPONSE ====  $response");
      return;
    } on UnauthorizedException catch (e) {
      debugPrint('This is the unauthorized part');
      state =FaqErrorState(error: e.message, errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.messages?.join(", ")}')
            .join("\n");
        state = FaqErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        debugPrint('going inside this BackendResponseError block bro');

        state = FaqErrorState(error: e.message, errorType: ErrorType.inline);
      } else {
        debugPrint('I guess it should be here');
        state = FaqErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      debugPrint('going inside this NoInternetConnectionException block bro');
      state = FaqErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      debugPrint('going inside this DioError block bro');
      debugPrint("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = FaqErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        debugPrint('ERROR RESPONSE: $errorResponse');
        debugPrint('Title: $title');
      }
      debugPrint(e.toString());
      state = FaqErrorState(error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future sendFeedback({required String email, required String feedback}) async {

    try {
      state = FeedbackLoadingState();
      final response = await helpSupportRepository.sendFeedback(email: email, feedback: feedback);
     // Update the provider state
      state =FeedbackSuccessfulState();
      // debugPrint(response);
      print("FEEDBACK RESPONSE ====  $response");
      return;
    } on UnauthorizedException catch (e) {
      debugPrint('This is the unauthorized part');
      state =FeedbackErrorState(error: e.message, errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.messages?.join(", ")}')
            .join("\n");
        state = FeedbackErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        debugPrint('going inside this BackendResponseError block bro');

        state = FeedbackErrorState(error: e.message, errorType: ErrorType.inline);
      } else {
        debugPrint('I guess it should be here');
        state = FeedbackErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      debugPrint('going inside this NoInternetConnectionException block bro');
      state = FeedbackErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      debugPrint('going inside this DioError block bro');
      debugPrint("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = FeedbackErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        debugPrint('ERROR RESPONSE: $errorResponse');
        debugPrint('Title: $title');
      }
      debugPrint(e.toString());
      state = FeedbackErrorState(error: e.toString(), errorType: ErrorType.other);
    }
  }



}



final learnMossYogaProvider = StateProvider<List<LearnMossYogaReponse>>((ref) => []);

final faqsProvider = StateProvider<List<FaqsReponse>>((ref) => []);