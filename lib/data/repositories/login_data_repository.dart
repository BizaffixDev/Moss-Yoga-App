import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moss_yoga/data/data_sources/login_data_soruce.dart';
import 'package:moss_yoga/data/models/fcm_device_token_request_model.dart';
import 'package:moss_yoga/data/models/fcm_device_token_response_model.dart';
import 'package:moss_yoga/data/models/forgot_password_response_model.dart';
import 'package:moss_yoga/data/models/login_response_model.dart';
import 'package:moss_yoga/data/models/otp_verification_response_model.dart';
import 'package:moss_yoga/data/models/reset_password_response_model.dart';
import 'package:moss_yoga/data/models/sign_up_response_model.dart';
import 'package:moss_yoga/data/models/signup_teacher_response_model.dart';
import 'package:moss_yoga/data/models/student_detail_request_model.dart';

import '../models/resend_otp_response.dart';
import '../models/student_detail_response_model.dart';

abstract class LoginRepository {
  Future<LoginResponseModel> getLoginCredentials(
      {required String email, required String password});

  Future<SignupResponseModel> getSignupStudentCredentials(
      {required String username,
      required String email,
      required String password});

  Future<SignUpTeacherResponse> getSignupTeacherCredentials(
      {required String username,
      required String email,
      required String password});

  ///Change the Type to ConfirmEmail
  Future<SignupResponseModel> confirmEmail();

  Future<ForgotPasswordResponseModel> forgotPassword({required email});

  Future<StudentDetailResponse> submitStudentDetails(
      {required StudentDetailRequest studentDetailRequest});

  Future<OtpVerificationResponseModel> otpVerification(
      {required String email, required String code});

  Future<ResendOtpResponse> resendOtp(
      {required String email});


  Future<LoginResponseModel> teacherProfilingDetail(
      {required FormData formData});

  Future<ResetPasswordResponseModel> resetPassword(
      {required String password, required String email});

  Future<LoginResponseModel> getLoginWithGoogle(
      {required GoogleSignInAccount body});

  Future<SignupResponseModel> signUpWithGoogle(
      {required GoogleSignInAccount body, required String userRole});

  Future<FcmDeviceTokenResponseModel> registerDeviceToken(
      {required DeviceTokenRequestModel deviceTokenRequestModel});
}

class LoginRepositoryImpl extends LoginRepository {
  final LoginDataSource loginDataSource;

  LoginRepositoryImpl(
    this.loginDataSource,
  );

  @override
  Future<LoginResponseModel> getLoginCredentials(
      {required String email, required String password}) {
    return loginDataSource.getLoginCredentials(
        email: email, password: password);
  }

  @override
  Future<SignupResponseModel> getSignupStudentCredentials(
      {required String username,
      required String email,
      required String password}) {
    return loginDataSource.getSignupStudentCredentials(
        username: username, email: email, password: password);
  }

  @override
  Future<SignUpTeacherResponse> getSignupTeacherCredentials(
      {required String username,
      required String email,
      required String password}) {
    return loginDataSource.getSignupTeacherCredentials(
        username: username, email: email, password: password);
  }

  @override
  Future<SignupResponseModel> confirmEmail() {
    return loginDataSource.confirmEmail();
  }

  @override
  Future<StudentDetailResponse> submitStudentDetails(
      {required StudentDetailRequest studentDetailRequest}) {
    return loginDataSource.submitStudentDetails(
        studentDetailRequest: studentDetailRequest);
  }

  @override
  Future<ForgotPasswordResponseModel> forgotPassword({required email}) {
    return loginDataSource.forgotPassword(email: email);
  }

  @override
  Future<OtpVerificationResponseModel> otpVerification(
      {required String email, required String code}) {
    return loginDataSource.otpVerification(email: email, code: code);
  }

  @override
  Future<ResetPasswordResponseModel> resetPassword(
      {required String email, required String password}) {
    return loginDataSource.resetPassword(email: email, password: password);
  }

  @override
  Future<LoginResponseModel> teacherProfilingDetail({required formData}) {
    // TODO: implement teacherProfilingDetail
    return loginDataSource.teacherProfilingDetail(formData: formData);
  }

  @override
  Future<LoginResponseModel> getLoginWithGoogle(
      {required GoogleSignInAccount body}) {
    return loginDataSource.getLoginWithGoogle(body: body);
  }

  @override
  Future<SignupResponseModel> signUpWithGoogle(
      {required GoogleSignInAccount body, required String userRole}) {
    return loginDataSource.signUpWithGoogle(
        queryParams: body, userRole: userRole);
  }

  @override
  Future<FcmDeviceTokenResponseModel> registerDeviceToken(
      {required DeviceTokenRequestModel deviceTokenRequestModel}) {
    return loginDataSource.registerDeviceToken(
        deviceTokenRequestModel: deviceTokenRequestModel);
  }

  @override
  Future<ResendOtpResponse> resendOtp({required String email}) {
    return loginDataSource.resendOtp(email: email);
  }
}
