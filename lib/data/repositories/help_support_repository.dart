import 'package:moss_yoga/data/data_sources/help_support_data_source.dart';
import 'package:moss_yoga/data/data_sources/student_account_data_source.dart';
import 'package:moss_yoga/data/models/delete_account_response.dart';
import 'package:moss_yoga/data/models/student_change_passwd_response_model.dart';

import '../models/faq_response.dart';
import '../models/feedback_reponse_model.dart';
import '../models/help_support_response_model.dart';

abstract class HelpSupportRepository {

  Future<List<LearnMossYogaReponse>> getLearnMossYogaData();

  Future<List<FaqsReponse>> getFaqs();


  Future<FeedbackResponse> sendFeedback({required String email, required String feedback});

}

class HelpSupportRepositoryImpl extends HelpSupportRepository {
  final HelpSupportDataSource helpSupportDataSource;

  HelpSupportRepositoryImpl(
      this.helpSupportDataSource,
      );

  @override
  Future<List<LearnMossYogaReponse>> getLearnMossYogaData() {
    return helpSupportDataSource.getLearnMossYogaData();
  }

  @override
  Future<List<FaqsReponse>> getFaqs() {
    return helpSupportDataSource.getFaqs();
  }

  @override
  Future<FeedbackResponse> sendFeedback({required String email, required String feedback}) {
    return helpSupportDataSource.sendFeedback(email: email, feedback: feedback);
  }




}
