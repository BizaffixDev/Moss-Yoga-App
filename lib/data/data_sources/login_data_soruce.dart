import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moss_yoga/data/data_sources/user_local_data_source.dart';
import 'package:moss_yoga/data/models/fcm_device_token_request_model.dart';
import 'package:moss_yoga/data/models/fcm_device_token_response_model.dart';
import 'package:moss_yoga/data/models/forgot_password_response_model.dart';
import 'package:moss_yoga/data/models/login_response_model.dart';
import 'package:moss_yoga/data/models/otp_verification_response_model.dart';
import 'package:moss_yoga/data/models/resend_otp_response.dart';
import 'package:moss_yoga/data/models/reset_password_response_model.dart';
import 'package:moss_yoga/data/models/sign_up_request_model.dart';
import 'package:moss_yoga/data/models/sign_up_response_model.dart';
import 'package:moss_yoga/data/models/sign_up_teacher_request_model.dart';
import 'package:moss_yoga/data/models/signup_teacher_response_model.dart';
import 'package:moss_yoga/data/network/end_points.dart';
import 'package:moss_yoga/data/network/rest_api_client.dart';

import '../models/student_detail_request_model.dart';
import '../models/student_detail_response_model.dart';

abstract class LoginDataSource {
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

  Future<ResetPasswordResponseModel> resetPassword(
      {required String email, required String password});

  Future<ResendOtpResponse> resendOtp(
      {required String email});

  Future<LoginResponseModel> teacherProfilingDetail(
      {required FormData formData});

  Future<LoginResponseModel> getLoginWithGoogle(
      {required GoogleSignInAccount body});

  Future<SignupResponseModel> signUpWithGoogle(
      {required GoogleSignInAccount queryParams, required String userRole});

  Future<FcmDeviceTokenResponseModel> registerDeviceToken(
      {required DeviceTokenRequestModel deviceTokenRequestModel});
}

class LoginDataSourceImpl implements LoginDataSource {
  LoginDataSourceImpl()
      : _restClient = GetIt.instance<ApiService>(),
        _userLocalDataSource = GetIt.instance<UserLocalDataSource>();

  final ApiService _restClient;
  final UserLocalDataSource _userLocalDataSource;

  @override
  Future<LoginResponseModel> getLoginCredentials(
      {required String email, required String password}) async {
    // try {
    Map<String, dynamic> queryParameters = {
      'Email': email,
      'Password': password,
    };
    var headers = {'accept': '*/*'};

    final result = await _restClient.post(
      Endpoints.loginUser,
      queryParameters,
      isSignUporLogin: true,
      options: Options(
        headers: headers,
      ),
    );
    debugPrint('This is the result $result');
    final response = LoginResponseModel.fromJson(result.data);
    debugPrint('This is the response $response');
    return response;
    // }
  }

  @override
  Future<SignupResponseModel> getSignupStudentCredentials(
      {required String username,
      required String email,
      required String password}) async {
    // try{
    SignupRequest data = SignupRequest(
        username: username,
        email: email,
        password: password,
        confirmPassword: password);

    final result = await _restClient.post(Endpoints.signupUser, data,
        isSignUporLogin: true);

    debugPrint('This is the result $result');
    if (result.data == null) {
      throw Exception('Empty response');
    }
    final response = SignupResponseModel.fromJson(result.data);
    debugPrint('This is the response $response');
    return response;
    // }catch (e){
    //   debugPrint("This is the caught e ${e.toString()}");
    //   debugPrint(e);
    //   rethrow;
    // }
  }

  @override
  Future<SignUpTeacherResponse> getSignupTeacherCredentials(
      {required String username,
      required String email,
      required String password}) async {
    // try{
    SignUpTeacherRequest data = SignUpTeacherRequest(
      username: username,
      email: email,
      password: password,
      roleId: 2,
    );

    final result = await _restClient.post(Endpoints.signupTeacher, data,
        isSignUporLogin: true);

    debugPrint('This is the result $result');
    if (result.data == null) {
      throw Exception('Empty response');
    }
    final response = SignUpTeacherResponse.fromJson(result.data);
    debugPrint('This is the response $response');
    return response;
    // }catch (e){
    //   debugPrint("This is the caught e ${e.toString()}");
    //   debugPrint(e);
    //   rethrow;
    // }
  }

  @override
  Future<SignupResponseModel> confirmEmail() async {
    ///Change to ConfirmEmail Body
    SignupRequest data = SignupRequest(
        username: 'username',
        email: 'email',
        password: 'password',
        confirmPassword: 'confirmPassword');

    final result = await _restClient.post(Endpoints.signupUser, data,
        isSignUporLogin: true);

    debugPrint('This is the result $result');
    if (result.data == null) {
      throw Exception('Empty response');
    }
    final response = SignupResponseModel.fromJson(result.data);
    debugPrint('This is the response $response');
    return response;
  }

  @override
  Future<StudentDetailResponse> submitStudentDetails(
      {required StudentDetailRequest studentDetailRequest}) async {
    try {
      // final userModel = await _userLocalDataSource.getUser();

      final result = await _restClient.post(
        Endpoints.saveStudentProileData,
        studentDetailRequest,
        //int.parse(jsonDecode(userModel!.userId.toString()).toString()),
        isSignUporLogin: true,
      );

      debugPrint('Student Detail Reqest====== $studentDetailRequest');
      debugPrint('Student User ID========  ${studentDetailRequest.userId}');
      if (result.data == null) {
        throw Exception('Empty response');
      }
      final response = StudentDetailResponse.fromJson(result.data);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ForgotPasswordResponseModel> forgotPassword({required email}) async {
    try {
      Map<String, dynamic> queryParameters = {
        'email': email,
      };
      var headers = {'accept': '*/*'};

      final result = await _restClient.get(Endpoints.forgotPassword,
          queryParameters: queryParameters,
          options: Options(
            headers: headers,
          ),
          isLogin: true);
      // Handle the response here
      // e.g., parse the response data or handle success/failure cases
      debugPrint('This is the result $result');
      if (result.statusCode == 200 || result.statusCode == 201) {
        final response = ForgotPasswordResponseModel.fromJson(result.data);
        debugPrint('This is the response $response');
        return response;
      } else {
        return ForgotPasswordResponseModel(
            message: 'The email field is required');
      }
    } catch (e) {
      // debugPrint(e);
      debugPrint("This is the caught e ${e.toString()}");
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  Future<OtpVerificationResponseModel> otpVerification(
      {required String email, required String code}) async {
    try {
      Map<String, dynamic> queryParameters = {'email': email, 'otp': code};
      var headers = {'accept': '*/*'};

      final result = await _restClient.get(Endpoints.otpVerification,
          queryParameters: queryParameters,
          options: Options(
            headers: headers,
          ),
          isLogin: true);
      // Handle the response here
      // e.g., parse the response data or handle success/failure cases
      debugPrint('This is the result $result');
      final response = OtpVerificationResponseModel.fromJson(result.data);
      debugPrint('This is the response ${response.message}');
      return response;
    } catch (e) {
      // debugPrint(e);
      debugPrint("This is the caught e ${e.toString()}");
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  Future<ResetPasswordResponseModel> resetPassword(
      {required String email, required String password}) async {
    try {
      Map<String, dynamic> queryParameters = {
        'email': email,
        'password': password,
        'ConfirmPassword': password,
      };
      var headers = {'accept': '*/*'};

      ///CHECK THE ENDPOINT MAYBE IT CHANGED
      final result = await _restClient.get(Endpoints.resetPassword,
          queryParameters: queryParameters,
          options: Options(
            headers: headers,
          ),
          isLogin: true);
      // Handle the response here
      // e.g., parse the response data or handle success/failure cases
      debugPrint('This is the result $result');
      if (result.statusCode == 200 || result.statusCode == 201) {
        final response = ResetPasswordResponseModel.fromJson(result.data);
        debugPrint('This is the response ${response.message}');
        return response;
      } else {
        return ResetPasswordResponseModel(
            message: 'Sorry some error occured, Try again.');
      }
    } catch (e) {
      debugPrint("This is the caught e ${e.toString()}");
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  Future<LoginResponseModel> teacherProfilingDetail(
      {required FormData formData}) async {
    try {
      var headers = {'accept': '*/*'};

      ///CHECK THE ENDPOINT MAYBE IT CHANGED
      final result = await _restClient.post(
        Endpoints.teacherDetailInfo,
        formData,
        options: Options(
          headers: headers,
        ),
      );
      // Handle the response here
      // e.g., parse the response data or handle success/failure cases
      debugPrint('This is the result $result');
      if (result.statusCode == 200 || result.statusCode == 201) {
        final response = LoginResponseModel.fromJson(result.data);
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

  @override
  Future<LoginResponseModel> getLoginWithGoogle(
      {required GoogleSignInAccount body}) async {
    try {
      final convertGoogleObjectToBody = {
        "id": body.id.toString(),
        "userName": body.displayName.toString(),
        "email": body.email.toString(),
        "profileImageUrl": body.photoUrl.toString(),
        "serverAuthCode": body.serverAuthCode.toString(),
      };
      print('Im hereeeee');
      // Map<String, dynamic> bodyToSend = convertGoogleObjectToBody;

      final result = await _restClient.post(
          Endpoints.loginWithGoogle, convertGoogleObjectToBody,
          isSignUporLogin: true);
      debugPrint('This is the result $result');
      final response = LoginResponseModel.fromJson(result.data);
      debugPrint('This is the response $response');
      return response;
    } catch (e) {
      // debugPrint(e);
      debugPrint("This is the caught e ${e.toString()}");
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  Future<SignupResponseModel> signUpWithGoogle(
      {required GoogleSignInAccount queryParams,
      required String userRole}) async {
    final convertGoogleObjectToBody = {
      "id": queryParams.id.toString(),
      "userName": queryParams.displayName.toString(),
      "email": queryParams.email.toString(),
      "profileImageUrl": queryParams.photoUrl.toString(),
      "serverAuthCode": queryParams.serverAuthCode.toString(),
      "userType": userRole,
    };
    print('Im hereeeee Now');

    final result = await _restClient.post(
        Endpoints.sigInWithGoogle, convertGoogleObjectToBody,
        isSignUporLogin: true);
    debugPrint('This is the result $result');
    final response = SignupResponseModel.fromJson(result.data);
    debugPrint('This is the response $response');
    return response;
  }

  @override
  Future<FcmDeviceTokenResponseModel> registerDeviceToken(
      {required DeviceTokenRequestModel deviceTokenRequestModel}) async {
    print(
        'Inside registerDeviceToken, sending token ${deviceTokenRequestModel.deviceToken}');
    print(
        'Inside registerDeviceToken, sending id ${deviceTokenRequestModel.userId}');
    // Map<String, dynamic> bodyToSend = convertGoogleObjectToBody;

    final result = await _restClient.post(
        Endpoints.registerDeviceToken, deviceTokenRequestModel,
        isSignUporLogin: true);
    debugPrint('This is the result $result');
    final response = FcmDeviceTokenResponseModel.fromJson(result.data);
    debugPrint('This is the response $response');
    return response;
  }

  @override
  Future<ResendOtpResponse> resendOtp({required String email}) async{
    final result = await _restClient.post(
        Endpoints.resendPassword, {
          "email": email
    },);
    debugPrint('This is the result from resend api $result');
    final response = ResendOtpResponse.fromJson(result.data);
    debugPrint('This is the response from resend api $response');
    return response;
  }
}
