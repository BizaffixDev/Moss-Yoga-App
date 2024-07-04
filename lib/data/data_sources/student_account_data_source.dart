import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/data_sources/user_local_data_source.dart';
import 'package:moss_yoga/data/models/student_change_passwd_request_model.dart';
import 'package:moss_yoga/data/models/student_change_passwd_response_model.dart';
import 'package:moss_yoga/data/models/update_profile_model.dart';
import 'package:moss_yoga/data/network/end_points.dart';
import 'package:moss_yoga/data/network/rest_api_client.dart';

import '../models/delete_account_response.dart';
import '../models/student_profile_detail_response.dart';
import '../models/update_student_profile_request_model.dart';

abstract class StudentAccountDataSource {

  Future<ChangePasswdResponseModel> studentChangePasswordCredentials(
      { required String email,
        required String currentpasswd,
        required String changepasswd,
        required String reenterpasswd});

  Future<DeleteAccountReponse> deleteAccountStudent(
      {required int userId});

  Future<StudentProfileDetailReponse> getStudentProfileDetails(
      {required int userId});


  Future<UpdateProfileResponse> updateStudentProfileDetails(
      {required UpdateStudentProfileRequest data});



}

  class StudentAccountDataSourceImp implements StudentAccountDataSource {
  StudentAccountDataSourceImp()
      : _restClient = GetIt.instance<ApiService>(),
        _userLocalDataSource = GetIt.instance<UserLocalDataSource>();

  final ApiService _restClient;
  final UserLocalDataSource _userLocalDataSource;

  @override
  Future<ChangePasswdResponseModel> studentChangePasswordCredentials(
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
          "userId":userId
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
  Future<StudentProfileDetailReponse> getStudentProfileDetails(
      {required int userId}) async{
    final result =
    await _restClient.get(Endpoints.studentPtofileDetails, queryParameters: {
      "userId":userId
    });

    debugPrint('This is the result ${result}');
    if (result.data == null) {
      throw Exception('Empty response');
    }
    final response = StudentProfileDetailReponse.fromJson(result.data);
    debugPrint('This is the response ${response}');
    return response;
  }

  @override
  Future<UpdateProfileResponse> updateStudentProfileDetails({required UpdateStudentProfileRequest data}) async{
    final result =
        await _restClient.put(Endpoints.updateStudentPtofileDetails, data,);

    debugPrint('This is the result $result');
    if (result.data == null) {
      throw Exception('Empty response');
    }
    final response = UpdateProfileResponse.fromJson(result.data);
    debugPrint('This is the response from update API  $response');
    return response;
  }



}
