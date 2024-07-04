
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/repositories/teacher_repositories/teacher_account_data_repository.dart';
import 'package:moss_yoga/presentation/screens/teachers_screens/teacher_profile_setting/teacher_account_states.dart';
import '../../../data/data_sources/user_local_data_source.dart';
import '../../../data/models/login_response_model.dart';
import '../../../data/models/user_gender_model.dart';
import '../../../data/network/error_handler_interceptor.dart';
import '../../screens/students_screens/student_profile_setting/student_account_states.dart';
import '../screen_state.dart';

final teacherAccountNotifierProvider = StateNotifierProvider<
    TeacherAccountNotifier, TeacherAccountStates>(
      (ref) => TeacherAccountNotifier(
    ref: ref,
        teacherAccountRepository: GetIt.I<TeacherAccountRepository>(),
    userLocalDataSource: GetIt.I<UserLocalDataSource>(),
  ),
);

class TeacherAccountNotifier
    extends StateNotifier<TeacherAccountStates> {
  TeacherAccountNotifier(
      {required this.ref, required this.teacherAccountRepository, required this.userLocalDataSource})
      : super(TeacherAccountInitialState());

  final Ref ref;
  final TeacherAccountRepository teacherAccountRepository;
  final UserLocalDataSource userLocalDataSource;

  Future changePassword(
      {required String email,
        required String currentpasswd,
        required String changepasswd,
        required String reenterpasswd}) async {

    try {
      state = TeacherChangePasswordLoadingState();
      final response = await teacherAccountRepository
          .teacherChangePasswordCredentials(
        email: email,
        currentpasswd: currentpasswd,
        changepasswd: changepasswd,
        reenterpasswd: reenterpasswd,
      );

      state = TeacherChangePasswordSuccessfulState();
      // debugPrint(response);
      print("CHANGE PASSWORD RESPONSE ====  $response");
      return;
    } on UnauthorizedException catch (e) {
      debugPrint('This is the unauthorized part');
      state = TeacherChangePasswordErrorState(error: e.message, errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.messages?.join(", ")}')
            .join("\n");
        state = TeacherChangePasswordErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        debugPrint('going inside this BackendResponseError block bro');

        state = TeacherChangePasswordErrorState(error: e.message, errorType: ErrorType.inline);
      } else {
        debugPrint('I guess it should be here');
        state = TeacherChangePasswordErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      debugPrint('going inside this NoInternetConnectionException block bro');
      state = TeacherChangePasswordErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      debugPrint('going inside this DioError block bro');
      debugPrint("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = TeacherChangePasswordErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        debugPrint('ERROR RESPONSE: $errorResponse');
        debugPrint('Title: $title');
      }
      debugPrint(e.toString());
      state = TeacherChangePasswordErrorState(error: e.toString(), errorType: ErrorType.other);
    }
  }


  Future deleteAccount(
      {required int userId,
      }) async {

    try {
      state = TeacherDeleteAccountLoadingState();
      final response = await teacherAccountRepository
          .deleteAccountTeacher(
        userId: userId,
      );

      state = TeacherDeleteAccountSuccessfulState();
      // debugPrint(response);
      print("DELETE ACCOUNT RESPONSE ====  $response");
      return;
    } on UnauthorizedException catch (e) {
      debugPrint('This is the unauthorized part');
      state = TeacherDeleteAccountErrorState(error: e.message, errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.messages?.join(", ")}')
            .join("\n");
        state = TeacherDeleteAccountErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        debugPrint('going inside this BackendResponseError block bro');

        state = TeacherDeleteAccountErrorState(error: e.message, errorType: ErrorType.inline);
      } else {
        debugPrint('I guess it should be here');
        state = TeacherDeleteAccountErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      debugPrint('going inside this NoInternetConnectionException block bro');
      state = TeacherDeleteAccountErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      debugPrint('going inside this DioError block bro');
      debugPrint("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = TeacherDeleteAccountErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        debugPrint('ERROR RESPONSE: $errorResponse');
        debugPrint('Title: $title');
      }
      debugPrint(e.toString());
      state = TeacherDeleteAccountErrorState(error: e.toString(), errorType: ErrorType.other);
    }
  }





  Future getProfileDetails()async{

    final userModel = await userLocalDataSource.getUser();
    try {
      state = TeacherProfileDetailsLoadingState();
      final response = await teacherAccountRepository
          .getTeacherProfileDetails(
          userId: userModel!.userId
      );




      ref.read(teacherFullName.notifier).state = response.fullName;
      ref.read(teacherEmail.notifier).state = response.emailAddress;
      ref.read(teacherAge.notifier).state = response.age;
      ref.read(teacherLatitude.notifier).state = response.latitude;
      ref.read(teacherLongitude.notifier).state = response.longitude;
      ref.read(teacherContactNumber.notifier).state = response.contactNumber;
      ref.read(teacherCountry.notifier).state = response.country;
      ref.read(teacherCity.notifier).state = response.city;
      ref.read(teacherDoc.notifier).state = response.dateOfCompletion;
      ref.read(teacherDob.notifier).state = response.dateOfBirth ?? "";
      ref.read(teacherLocation.notifier).state = response.location ?? "" ;
      ref.read(teacherEducation.notifier).state = response.education ?? "";
      //ref.read(teacherEducation.notifier).state = response.institute ?? "";
      ref.read(teacherYoc.notifier).state = response.yearOfExperience ;
      ref.read(teacherGender.notifier).state = response.gender;
      ref.read(teacherDescription.notifier).state = response.description ?? "";
      ref.read(teacherOccupation.notifier).state = response.occupation;
      ref.read(teacherSpeciality.notifier).state = response.speciality;


      state =TeacherProfileDetailsSuccessfulState();
      // debugPrint(response);
      print("USER DETAIL RESPONSE ====  $response");
      print("USER YEAR OF EXPERIENCE ====  ${ref.read(teacherYoc.notifier).state}");
      return;
    } on UnauthorizedException catch (e) {
      debugPrint('This is the unauthorized part');
      state = TeacherProfileDetailsErrorState(error: e.message, errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.messages?.join(", ")}')
            .join("\n");
        state = TeacherProfileDetailsErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        debugPrint('going inside this BackendResponseError block bro');

        state = TeacherProfileDetailsErrorState(error: e.message, errorType: ErrorType.inline);
      } else {
        debugPrint('I guess it should be here');
        state = TeacherProfileDetailsErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      debugPrint('going inside this NoInternetConnectionException block bro');
      state = TeacherProfileDetailsErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      debugPrint('going inside this DioError block bro');
      debugPrint("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = TeacherProfileDetailsErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        debugPrint('ERROR RESPONSE: $errorResponse');
        debugPrint('Title: $title');
      }
      debugPrint(e.toString());
      state = TeacherProfileDetailsErrorState(error: e.toString(), errorType: ErrorType.other);
    }
  }


  Future getTeacherData() async{
    LoginResponseModel? user = await userLocalDataSource.getUser();
    print(user?.userType.toString());
    print(user?.email.toString());
    print(user?.userId.toString());
    print(user?.username.toString());
    ref.read(teacherObjectProvider.notifier).state = user!;

    ref.read(teacherFullName.notifier).state = user.username;
    ref.read(teacherEmail.notifier).state = user.email;
    ref.read(teacherId.notifier).state = user.userId;

  }


  Future<void> updateTeacherprofile({

    required String contactNumber,
    required String location,
    required String education,
    required String dob,
    required String doc,
    required int yoc,
    required String gender,



}) async {
    var getTecherId = await userLocalDataSource.getUser();
    print('This is the teacher id ${getTecherId?.userId.toString()}');

    final formData = FormData.fromMap({
      'TeacherId': getTecherId?.userId.toString(),
      'FullName': ref.read(teacherFullName),
      'EmailAddress': ref.read(teacherEmail),
      'Age': ref.read(teacherAge),
      'Latitude': 40.785091,
      'Longitude': -73.968285,
      'ContactNumber': contactNumber,
      'Country': ref.read(teacherCountry),
      'City': ref.read(teacherCity),
      'DateOfBirth': dob,
      'Gender': gender,
      'Headline': ref.read(teacherDescription),
      'Location': location,
      'Education':education,
      'DateOfCompletion': doc,
      'Occupation': ref.read(teacherOccupation),
      'Description': ref.read(teacherDescription),
      'Speciality': ref.read(teacherSpeciality),
      'Institute': ref.read(teacherEducation),
      'YearOfExperience': yoc,
      'ProfilePicture':

      await MultipartFile.fromFile(
        ref
            .read(teacherProfileImagePathProvider.notifier)
            .state,
        filename: ref
            .read(teacherProfileImageNameProvider.notifier)
            .state,
      ),

      'Certification':

    await MultipartFile.fromFile(
          ref
              .read(teacherCertificateFilePathProvider.notifier)
              .state
              ?.path ??
              '',
          filename:
          ref
              .read(teacherCertificateFileNameProvider.notifier)
              .state ??
              ''),






    });

    try {
      state = UpdateTeacherProfileDetailsLoadingState();
      final response =
      await teacherAccountRepository.updateTeacherProfile(formData: formData);

      ///Remove this if it casues error.
      if (response.message == 'Profile Updated Successfully!') {

        state = UpdateTeacherProfileDetailsSuccessfulState();
      } else {
        state = UpdateTeacherProfileDetailsErrorState(
            error: response.message.toString(), errorType: ErrorType.inline);
      }
    } on UnauthorizedException catch (e) {
      debugPrint('This is the unauthorized part');
      state = UpdateTeacherProfileDetailsErrorState(
          error: e.message.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = UpdateTeacherProfileDetailsErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        debugPrint('going inside this BackendResponseError block bro');

        state = UpdateTeacherProfileDetailsErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        debugPrint('I guess it should be here');
        state = UpdateTeacherProfileDetailsErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      debugPrint('going inside this NoInternetConnectionException block bro');
      state = UpdateTeacherProfileDetailsErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      debugPrint('going inside this DioError block bro');
      debugPrint("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = UpdateTeacherProfileDetailsErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        debugPrint('ERROR RESPONSE: $errorResponse');
        debugPrint('Title: $title');
      }
      debugPrint(e.toString());
      state = UpdateTeacherProfileDetailsErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }


}

final teacherObjectProvider = StateProvider<LoginResponseModel>((ref) =>
    LoginResponseModel(
        userId: -1,
        email: '',
        username: '',
        token: '-1',
        userType: 'userType',
        message: 'message',
        isVerified: false));




final teacherId = StateProvider<int>((ref) {
  return 0;
});

final teacherFullName = StateProvider<String>((ref) {
  return "";
});

final teacherEmail = StateProvider<String>((ref) {
  return "";
});

final teacherAge = StateProvider<int>((ref) {
  return 0;
});

final teacherLatitude = StateProvider<double>((ref) {
  return 0.0;
});

final teacherLongitude = StateProvider<double>((ref) {
  return 0.0;
});


final teacherContactNumber = StateProvider<String>((ref) {
  return "";
});

final teacherCountry = StateProvider<String>((ref) {
  return "";
});

final teacherCity = StateProvider<String>((ref) {
  return "";
});

final teacherDob = StateProvider<String>((ref) {
  return "";
});

final teacherGender = StateProvider<String>((ref) {
  return UserGender.female.toString();
});

final teacherHeadline = StateProvider<String>((ref) {
  return "";
});

final teacherSpeciality = StateProvider<String>((ref) {
  return "";
});

final teacherInstitute= StateProvider<String>((ref) {
  return "";
});

final teacherLocation = StateProvider<String>((ref) {
  return "";
});

final teacherEducation = StateProvider<String>((ref) {
  return "";
});

final teacherDoc = StateProvider<String>((ref) {
  return "";
});

final teacherDescription= StateProvider<String>((ref) {
  return "";
});

final teacherYoc= StateProvider<int>((ref) {
  return 0;
});

final teacherOccupation= StateProvider<String>((ref) {
  return "";
});




final teacherProfileImageNameProvider = StateProvider<String>(
      (ref) => "",
);

final teacherProfileImagePathProvider = StateProvider<String>(
      (ref) => "",
);

final teacherCertificateFileNameProvider = StateProvider<String>(
      (ref) => "",
);

final teacherCertificateFilePathProvider = StateProvider<File?>(
      (ref) => null,
);

