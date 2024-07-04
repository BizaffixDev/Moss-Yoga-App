import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/data_sources/user_local_data_source.dart';
import 'package:moss_yoga/data/models/help_support_response_model.dart';

import '../models/faq_response.dart';
import '../models/feedback_reponse_model.dart';
import '../network/end_points.dart';
import '../network/rest_api_client.dart';



abstract class HelpSupportDataSource {


  Future<List<LearnMossYogaReponse>> getLearnMossYogaData();

  Future<List<FaqsReponse>> getFaqs();

  Future<FeedbackResponse> sendFeedback({required String email, required String feedback});



}



class HelpSupportDataSourceImpl implements HelpSupportDataSource {
  HelpSupportDataSourceImpl()
      : _restClient = GetIt.instance<ApiService>(),
        _userLocalDataSource = GetIt.instance<UserLocalDataSource>();

  final ApiService _restClient;
  final UserLocalDataSource _userLocalDataSource;




  @override
  Future<List<LearnMossYogaReponse>> getLearnMossYogaData() async {
    final result = await _restClient.get(
      Endpoints.learnMossYogaData,
      queryParameters: {},
    );
    print('This is the result of Poses List ${result}');
    final response = learnMossYogaReponseFromJson(json.encode(result.data));
    print('This is the response of decoded List ${response}');
    return response;
  }

  @override
  Future<List<FaqsReponse>> getFaqs() async{
    final result = await _restClient.get(
      Endpoints.faqs,
      queryParameters: {},
    );
    print('This is the result of Poses List ${result}');
    final response = faqsReponseFromJson(json.encode(result.data));
    print('This is the response of decoded List ${response}');
    return response;
  }

  @override
  Future<FeedbackResponse> sendFeedback({required String email, required String feedback}) async{

    var data = {
      "email": email,
    "body": feedback,
  };

    final result =
        await _restClient.post(Endpoints.feedback,data );

    debugPrint('This is the result ${result}');
    if (result.data == null) {
      throw Exception('Empty response');
    }
    final response = FeedbackResponse.fromJson(result.data);
    debugPrint('This is the response ${response}');
    return response;
  }
  }








