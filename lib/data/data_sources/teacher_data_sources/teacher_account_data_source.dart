import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/data_sources/user_local_data_source.dart';
import 'package:moss_yoga/data/models/get_teacher_profile_response.dart';
import 'package:moss_yoga/data/models/student_change_passwd_request_model.dart';
import 'package:moss_yoga/data/models/student_change_passwd_response_model.dart';
import 'package:moss_yoga/data/network/end_points.dart';
import 'package:moss_yoga/data/network/rest_api_client.dart';

import '../../models/delete_account_response.dart';
import '../../models/update_profile_model.dart';



abstract class TeacherAccountDataSource {

  Future<ChangePasswdResponseModel> teacherChangePasswordCredentials(
      { required String email,
        required String currentpasswd,
        required String changepasswd,
        required String reenterpasswd});

  Future<DeleteAccountReponse> deleteAccountStudent(
      {required int userId});

  Future<GetTeacherProfileResponse> getTeacherProfileDetails(
      {required int userId});

  Future<UpdateProfileResponse> updateTeacherProfile(
      {required FormData formData});


}

class TeacherAccountDataSourceImp implements TeacherAccountDataSource {
  TeacherAccountDataSourceImp()
      : _restClient = GetIt.instance<ApiService>(),
        _userLocalDataSource = GetIt.instance<UserLocalDataSource>();

  final ApiService _restClient;
  final UserLocalDataSource _userLocalDataSource;

  @override
  Future<ChangePasswdResponseModel> teacherChangePasswordCredentials(
      { required String email,
        required String currentpasswd,
        required String changepasswd,
        required String reenterpasswd}) async {
    // try{
    ChangePasswdRequestModel data = ChangePasswdRequestModel(
        email: email,
        oldPassword: currentpasswd,
        newPassword: changepasswd,
        confirmPassword: reenterpasswd);

    final result =
    await _restClient.post(Endpoints.stdChangePasswd, data,);

    debugPrint('This is the result $result');
    if (result.data == null) {
      throw Exception('Empty response');
    }
    final response = ChangePasswdResponseModel.fromJson(result.data);
    debugPrint('This is the response $response');
    return response;
  }

  @override
  Future<DeleteAccountReponse> deleteAccountStudent({required int userId}) async{


    final result =
    await _restClient.get(Endpoints.deleteAccountStudent, queryParameters: {
      "teacherId":userId
    });

    debugPrint('This is the result $result');
    if (result.data == null) {
      throw Exception('Empty response');
    }
    final response = DeleteAccountReponse.fromJson(result.data);
    debugPrint('This is the response ${response}');
    return response;
  }


  @override
  Future<GetTeacherProfileResponse> getTeacherProfileDetails(
      {required int userId}) async{
    final result =
    await _restClient.get(Endpoints.teacherPtofileDetails, queryParameters: {
      "USERID":userId
    });

    debugPrint('This is the result ${result}');
    if (result.data == null) {
      throw Exception('Empty response');
    }
    final response = GetTeacherProfileResponse.fromJson(result.data);
    debugPrint('This is the response ${response}');
    return response;
  }

  @override
  Future<UpdateProfileResponse> updateTeacherProfile({required FormData formData}) async{
    try {
      var headers = {'accept': '*/*'};

      ///CHECK THE ENDPOINT MAYBE IT CHANGED
      final result = await _restClient.post(
        Endpoints.updateTeacherPtofileDetails,
        formData,
        options: Options(
          headers: headers,
        ),
      );
      // Handle the response here
      // e.g., parse the response data or handle success/failure cases
      debugPrint('This is the result $result');
      if (result.statusCode == 200 || result.statusCode == 201) {
        final response = UpdateProfileResponse.fromJson(result.data);
        debugPrint('This is the response $response');
        return response;
      }
      print('This is the else block one i.e. status code isnt 200 or 201 bro');
      return result.data;
    } catch (e) {
      debugPrint("This is the caught e ${e.toString()}");
      debugPrint(e.toString());
      rethrow;
    }
  }



}
