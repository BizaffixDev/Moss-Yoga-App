
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/data_sources/user_local_data_source.dart';


import '../models/previous_teachers_model.dart';
import '../network/end_points.dart';
import '../network/rest_api_client.dart';

abstract class MyTeachersDataSource {




  Future<List<PreviousTeachersResponseModel>> getPreviousTeachers({required String studentId});

}


class MyTeachersDataSourceImpl implements MyTeachersDataSource {

  MyTeachersDataSourceImpl()
      : _restClient = GetIt.instance<ApiService>(),
        _userLocalDataSource = GetIt.instance<UserLocalDataSource>();

  final ApiService _restClient;
  final UserLocalDataSource _userLocalDataSource;

  @override
  Future<List<PreviousTeachersResponseModel>> getPreviousTeachers({required String studentId}) async{
    final result = await _restClient.get(
      Endpoints.getPreviousTeachers,
      queryParameters: {
        "studentId":studentId
      },
    );
    print('This is the result of previous teachers List $result');
    final response =
    previousTeacherResponseModelFromJson(json.encode(result.data));
    print('This is the response of decoded List $response');
    return response;
  }









}
