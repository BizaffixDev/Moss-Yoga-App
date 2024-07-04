import 'package:moss_yoga/data/models/login_response_model.dart';
import 'package:moss_yoga/presentation/providers/screen_state.dart';

import '../../../../../data/models/chronic_response_model.dart';
import '../../../../../data/models/physical_response_model.dart';

abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthLoadingState extends AuthStates {}

class SignUpStudentLoadingState extends AuthStates {}

class SignUpTeacherLoadingState extends AuthStates {}

class LoginLoadingState extends AuthStates {}

class GoogleLoginLoadingState extends AuthStates {}

class GoogleSignUpLoadingState extends AuthStates {}

class ForgotPasswordLoadingState extends AuthStates {}


class ResendOtpLoadingState extends AuthStates {}

class OTPVerificationLoadingState extends AuthStates {}

class OTPEmailVerificationLoadingState extends AuthStates {}

class OTPEmailVerificationStudentLoadingState extends AuthStates {}

class OTPEmailVerificationTeacherLoadingState extends AuthStates {}

class PhysicaLoadingState extends AuthStates {}

class ChronicalLoadingState extends AuthStates {}

class ProflingStudentLoadingState extends AuthStates {}

class ProflingTeacherLoadingState extends AuthStates {}

class AuthSuccessfulState extends AuthStates {}

class AuthSuccessfulGoogleTeacherLoginInState extends AuthStates {
  AuthSuccessfulGoogleTeacherLoginInState({required this.isVerified});

  bool isVerified;
}

class AuthSuccessfulGoogleStudentLoginInState extends AuthStates {}

class AuthSuccessfulGoogleLoginBothUserExistInState extends AuthStates {
  AuthSuccessfulGoogleLoginBothUserExistInState(
      {required this.loginResponseModel});

  LoginResponseModel loginResponseModel;
}

class AuthSuccessfulGoogleSignUpState extends AuthStates {}

class ChronicSuccessfulState extends AuthStates {
  final List<ChronicResponseModel> chronicResponseList;

  ChronicSuccessfulState({required this.chronicResponseList});
}

class PhysicalSuccessfulState extends AuthStates {
  final List<PhysicalResponseModel> physicalResponseList;

  PhysicalSuccessfulState({required this.physicalResponseList});
}

class LoginSuccessfulState extends AuthStates {}

class LoginSuccessfulTeacherState extends AuthStates {
  LoginSuccessfulTeacherState({required this.isVerified});

  bool isVerified;
}

class LoginSuccessfulBothUserTypesState extends AuthStates {
  LoginSuccessfulBothUserTypesState({required this.loginResponseModel});

  LoginResponseModel loginResponseModel;
}

class ProflingStudentSuccessfulState extends AuthStates {}

class ProflingTeacherSuccessfulState extends AuthStates {}

class ForgotPasswordSuccessfulState extends AuthStates {}

class ResendOtpSuccessfulState extends AuthStates {}

class ForgotPasswordErrorState extends AuthStates {
  final ErrorType errorType;
  final String error;

  ForgotPasswordErrorState({required this.error, required this.errorType});
}

class ChronicalListErrorState extends AuthStates {
  final ErrorType errorType;
  final String error;

  ChronicalListErrorState({required this.error, required this.errorType});
}

class ProfilingTeacherErrorState extends AuthStates {
  final ErrorType errorType;
  final String error;

  ProfilingTeacherErrorState({required this.error, required this.errorType});
}

class OTPVerificationSuccessfulState extends AuthStates {}

class OTPVerificationStudentSuccessfulState extends AuthStates {}

class OTPVerificationTeacherSuccessfulState extends AuthStates {}

class OTPEmailVerificationSuccessfulState extends AuthStates {}

class ResetPasswordSuccessfulState extends AuthStates {}

class ResetPasswordLoadingState extends AuthStates {}

class OTPVerificationErrorState extends AuthStates {
  final ErrorType errorType;
  final String error;

  OTPVerificationErrorState({required this.error, required this.errorType});
}


class ResendOtpErrorState extends AuthStates {
  final ErrorType errorType;
  final String error;

  ResendOtpErrorState({required this.error, required this.errorType});
}


class OTPVerificationStudentErrorState extends AuthStates {
  final ErrorType errorType;
  final String error;

  OTPVerificationStudentErrorState(
      {required this.error, required this.errorType});
}

class OTPVerificationTeacherErrorState extends AuthStates {
  final ErrorType errorType;
  final String error;

  OTPVerificationTeacherErrorState(
      {required this.error, required this.errorType});
}

class ResetPasswordErrorState extends AuthStates {
  final ErrorType errorType;
  final String error;

  ResetPasswordErrorState({required this.error, required this.errorType});
}

class SignupSuccessfulStudentState extends AuthStates {}

class SignupSuccessfulTeacherState extends AuthStates {}

class AuthErrorState extends AuthStates {
  final ErrorType errorType;
  final String error;

  AuthErrorState({required this.error, required this.errorType});
}

class LoginErrorState extends AuthStates {
  final ErrorType errorType;
  final String error;

  LoginErrorState({required this.error, required this.errorType});
}

class GoogleLoginErrorState extends AuthStates {
  final ErrorType errorType;
  final String error;

  GoogleLoginErrorState({required this.error, required this.errorType});
}

class GoogleSignUpErrorState extends AuthStates {
  final ErrorType errorType;
  final String error;

  GoogleSignUpErrorState({required this.error, required this.errorType});
}
