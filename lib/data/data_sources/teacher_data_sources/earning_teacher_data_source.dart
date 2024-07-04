
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/data_sources/user_local_data_source.dart';
import 'package:moss_yoga/data/models/my_class_teacher_request_model.dart';
import 'package:moss_yoga/data/models/my_classes_teacher_response_model.dart';

import '../../models/earnings_teacher_response_model.dart';
import '../../network/end_points.dart';
import '../../network/rest_api_client.dart';



abstract class EarningsTeacherDataSource {


  Future<EarningsTeacherResponse> getTotalEarningTeacher({required String teacherId});


}


class EarningsTeacherDataSourceImpl implements EarningsTeacherDataSource {

  EarningsTeacherDataSourceImpl()
      : _restClient = GetIt.instance<ApiService>(),
        _userLocalDataSource = GetIt.instance<UserLocalDataSource>();

  final ApiService _restClient;
  final UserLocalDataSource _userLocalDataSource;

  @override
  Future<EarningsTeacherResponse> getTotalEarningTeacher({required String teacherId}) async{
    final result =
    await _restClient.get(Endpoints.totalEarningTeacher, queryParameters: {
    "teacherId": teacherId,
    });

    debugPrint('This is the result od earning api  $result');
    if (result.data == null) {
      throw Exception('Empty response');
    }
    final response = earningsTeacherResponseFromJson(json.encode(result.data));
    debugPrint('This is the response from earning api $response');
    return response;
  }



}
