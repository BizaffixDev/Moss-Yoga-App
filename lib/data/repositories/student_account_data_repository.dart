import 'package:moss_yoga/data/data_sources/student_account_data_source.dart';
import 'package:moss_yoga/data/models/delete_account_response.dart';
import 'package:moss_yoga/data/models/student_change_passwd_response_model.dart';

import '../models/student_profile_detail_response.dart';
import '../models/update_profile_model.dart';
import '../models/update_student_profile_request_model.dart';

abstract class StudentAccountRepository {

  Future<ChangePasswdResponseModel> getStudentChangePasswordCredentials(
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

class StudentAccountRepositoryImpl extends StudentAccountRepository {
  final StudentAccountDataSource studentChangePasswdDataSource;

  StudentAccountRepositoryImpl(
      this.studentChangePasswdDataSource,
      );

@override
  Future<ChangePasswdResponseModel> getStudentChangePasswordCredentials(
    { required String email,
      required String currentpasswd,
      required String changepasswd,
      required String reenterpasswd}) {
  return studentChangePasswdDataSource.studentChangePasswordCredentials(
      email: email,
      currentpasswd: currentpasswd,
      changepasswd: changepasswd,
      reenterpasswd: reenterpasswd,
     );
  }

  @override
  Future<DeleteAccountReponse> deleteAccountStudent({required int userId}) {
    return studentChangePasswdDataSource.deleteAccountStudent(userId: userId);
  }

  @override
  Future<StudentProfileDetailReponse> getStudentProfileDetails({required int userId}) {
    return studentChangePasswdDataSource.getStudentProfileDetails(userId: userId);
  }

  @override
  Future<UpdateProfileResponse> updateStudentProfileDetails({required data}) {
    return studentChangePasswdDataSource.updateStudentProfileDetails(data: data);
  }



}
