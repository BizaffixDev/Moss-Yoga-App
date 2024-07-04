
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:moss_yoga/data/network/rest_api_client.dart';

import '../models/notification_response_model.dart';
import '../network/end_points.dart';



abstract class NotificationStudentDataSource {

  Future<NotificationResponse> getNotifications(
      {required int userId, });
  
}

class NotificationStudentDataSourceImpl extends NotificationStudentDataSource {
  NotificationStudentDataSourceImpl() : _restClient = GetIt.instance<ApiService>();

  final ApiService _restClient;



  @override
  Future<NotificationResponse> getNotifications({required int userId,}) async{
    final result =
        await _restClient.get(Endpoints.notification + '/$userId/Student', queryParameters: {

    });

    debugPrint('This is the result $result');
    if (result.data == null) {
      throw Exception('Empty response');
    }
    final response = NotificationResponse.fromJson(result.data);
    debugPrint('This is the response ${response}');
    return response;
  }


}
