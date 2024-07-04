import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/repositories/teacher_repositories/earning_teacher_repository.dart';
import 'package:moss_yoga/presentation/screens/teachers_screens/earnings/earning_states.dart';

import '../../../data/data_sources/user_local_data_source.dart';
import '../../../data/models/earnings_teacher_response_model.dart';
import '../../../data/models/login_response_model.dart';
import '../../../data/network/error_handler_interceptor.dart';
import '../screen_state.dart';
import 'home_teacher_provider.dart';

final earningsTeacherNotifierProvider =
StateNotifierProvider<EarningsTeacherNotifier, EarningsTeacherStates>(
      (ref) => EarningsTeacherNotifier(
    ref: ref,
        earningsTeacherRepository: GetIt.I<EarningsTeacherRepository>(),
    userLocalDataSource: GetIt.I<UserLocalDataSource>(),
  ),
);

class EarningsTeacherNotifier extends StateNotifier<EarningsTeacherStates> {
  EarningsTeacherNotifier(
      {required this.ref,
        required this.earningsTeacherRepository,
        required this.userLocalDataSource})
      : super(EarningsTeacherInitialState());

  final Ref ref;
  final EarningsTeacherRepository earningsTeacherRepository;
  final UserLocalDataSource userLocalDataSource;

  final teacherObjectProvider = StateProvider<LoginResponseModel>((ref) =>
      LoginResponseModel(
          userId: -1,
          email: '',
          username: '',
          token: '-1',
          userType: 'userType',
          message: 'message',
          isVerified: false));

  Future getTeacherData() async {
    LoginResponseModel? user = await userLocalDataSource.getUser();
    print(user?.userType.toString());
    print(user?.email.toString());
    print(user?.userId.toString());
    print(user?.username.toString());
    ref.read(teacherObjectProvider.notifier).state = user!;

    ref.read(nameProvider.notifier).state = user.username;
    ref.read(teacherIdProvider.notifier).state = user.userId;
    ref.read(emailProvider.notifier).state = user.email;

    print(
        "TEACHER ID =========== ${ref.read(teacherIdProvider.notifier).state}");
  }



  Future getEarningTeacher({required String teacherId}) async{


    try {
      state = EarningsTeacherLoadingState();
      final response = await earningsTeacherRepository.getTotalEarningTeacher(
          teacherId: teacherId);
      state =  EarningsTeacherSuccessfulState();

      final detailsListNotifier =
      ref.read(studentDetailListProvider.notifier);



      detailsListNotifier.deleteAllStudentDetailList();

      detailsListNotifier.updateStudentDetailList(response.details);

      ref.read(totalEarningProvider.notifier).state = response.totalEarnings;


      print("UPCOMING CLASSES =========     $detailsListNotifier");
      print("Total Earnings ${
          ref.read(totalEarningProvider)}");

      return response;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = EarningsTeacherErrorState(
          error: e.message, errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = EarningsTeacherErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = EarningsTeacherErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = EarningsTeacherErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = EarningsTeacherErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = EarningsTeacherErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = EarningsTeacherErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }




}



final totalEarningProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});



class StudentDetailListNotifier extends StateNotifier<List<Detail>> {
  StudentDetailListNotifier() : super([]);

  updateStudentDetailList(List<Detail> studentDetails) {
    state = studentDetails;
  }

  deleteAllStudentDetailList() {
    state = []; // Set the state to an empty list to delete all teachers
  }

  // Cancel any active subscriptions or event listeners here
  @override
  void dispose() {
    // Dispose any resources (e.g., cancel streams, subscriptions, etc.)
    // This is important to prevent using the notifier after it's been disposed.
    super.dispose();
  }
}

final  studentDetailListProvider =
StateNotifierProvider<StudentDetailListNotifier, List<Detail>>(
      (ref) => StudentDetailListNotifier(),
);


