import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/models/previous_teachers_model.dart';
import 'package:moss_yoga/data/repositories/my_teachers_repository.dart';
import 'package:moss_yoga/presentation/providers/screen_state.dart';

import '../../data/data_sources/user_local_data_source.dart';
import '../../data/models/login_response_model.dart';
import '../../data/network/error_handler_interceptor.dart';
import '../screens/students_screens/my_teacher/my_teachers_states.dart';

final myTeachersNotifierProvider = StateNotifierProvider<MyTeachersNotifier, MyTeachersStates>(
      (ref) => MyTeachersNotifier(
    ref: ref,
        myTeachersRepository: GetIt.I<MyTeachersRepository>(),
    userLocalDataSource: GetIt.I<UserLocalDataSource>(),
  ),
);


class MyTeachersNotifier extends StateNotifier<MyTeachersStates> {
  MyTeachersNotifier(
      {required this.ref, required this.myTeachersRepository,  required this.userLocalDataSource,})
      : super(MyTeacherstInitialState());

  final Ref ref;
  final MyTeachersRepository myTeachersRepository;
  final UserLocalDataSource userLocalDataSource;


  Future getPreviousTeachers({required String studentId}) async {
    try {
      state = MyTeachersLoadingState();
      final response = await myTeachersRepository.getPreviousTeachers(studentId: studentId);

      //ref.read(previousTeachersProvider).addAll(response);


      state =  MyTeachersSuccessfulState();

      final teacherListProvider = ref.read(previousTeachersProvider.notifier);
      teacherListProvider.deleteAllTeacher();
      teacherListProvider.updateTeachers(response);
      print(response);
      return;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = MyTeachersErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = MyTeachersErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = MyTeachersErrorState(error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = MyTeachersErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = MyTeachersErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = MyTeachersErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = MyTeachersErrorState(error: e.toString(), errorType: ErrorType.other);
    }
  }





}



class PreviousTeachersNotifier
    extends StateNotifier<List<PreviousTeachersResponseModel>> {
  PreviousTeachersNotifier() : super([]);

  updateTeachers(List<PreviousTeachersResponseModel> teacher) {
    state = teacher;
  }

  deleteAllTeacher() {
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

final previousTeachersProvider = StateNotifierProvider<PreviousTeachersNotifier,
    List<PreviousTeachersResponseModel>>(
      (ref) => PreviousTeachersNotifier(),
);


class SavedPreviousTeacherNotifier
    extends StateNotifier<List<PreviousTeachersResponseModel>> {
  SavedPreviousTeacherNotifier() : super([]);

  void addTeacher(PreviousTeachersResponseModel teacher) {
    state = [...state, teacher];
  }

  void deleteTeacher(int teacherId) {
    state = state.where((teacher) => teacher.teacherId != teacherId).toList();
  }
}

final savedPreviousTeacherProvider = StateNotifierProvider<SavedPreviousTeacherNotifier,
    List<PreviousTeachersResponseModel>>(
      (ref) => SavedPreviousTeacherNotifier(),
);