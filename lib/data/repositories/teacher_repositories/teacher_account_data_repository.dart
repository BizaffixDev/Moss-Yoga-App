import 'package:dio/dio.dart';
import 'package:moss_yoga/data/data_sources/student_account_data_source.dart';
import 'package:moss_yoga/data/models/delete_account_response.dart';
import 'package:moss_yoga/data/models/get_teacher_profile_response.dart';
import 'package:moss_yoga/data/models/student_change_passwd_response_model.dart';

import '../../data_sources/teacher_data_sources/teacher_account_data_source.dart';
import '../../models/update_profile_model.dart';



abstract class TeacherAccountRepository {

  Future<ChangePasswdResponseModel> teacherChangePasswordCredentials(
      { required String email,
        required String currentpasswd,
        required String changepasswd,
        required String reenterpasswd});

  Future<DeleteAccountReponse> deleteAccountTeacher(
      {required int userId});

  Future<GetTeacherProfileResponse> getTeacherProfileDetails(
      {required int userId});

  Future<UpdateProfileResponse> updateTeacherProfile(
      {required FormData formData});

}

class TeacherAccountRepositoryImpl extends TeacherAccountRepository {
  final TeacherAccountDataSource teacherAccountDataSource;

  TeacherAccountRepositoryImpl(
      this.teacherAccountDataSource,
      );

  @override
  Future<ChangePasswdResponseModel> teacherChangePasswordCredentials(
      { required String email,
        required String currentpasswd,
        required String changepasswd,
        required String reenterpasswd}) {
    return teacherAccountDataSource.teacherChangePasswordCredentials(
      email: email,
      currentpasswd: currentpasswd,
      changepasswd: changepasswd,
      reenterpasswd: reenterpasswd,
    );
  }

  @override
  Future<DeleteAccountReponse> deleteAccountTeacher({required int userId}) {
    return teacherAccountDataSource.deleteAccountStudent(userId: userId);
  }

  @override
  Future<GetTeacherProfileResponse> getTeacherProfileDetails({required int userId}) {
    return teacherAccountDataSource.getTeacherProfileDetails(userId: userId);
  }

  @override
  Future<UpdateProfileResponse> updateTeacherProfile({required FormData formData}) {
    return teacherAccountDataSource.updateTeacherProfile(formData: formData);
  }
}
