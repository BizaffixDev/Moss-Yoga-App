import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/models/home_guide_response_model.dart';
import 'package:moss_yoga/data/models/yoga_poses_response_model.dart';
import 'package:moss_yoga/data/models/yoga_styles_response_model.dart';
import 'package:moss_yoga/data/network/error_handler_interceptor.dart';
import 'package:moss_yoga/data/repositories/teacher_repositories/teacher_home_repository.dart';
import 'package:moss_yoga/presentation/providers/screen_state.dart';
import 'package:moss_yoga/presentation/screens/teacher_locked_screens/states/home_teacher_locked_states.dart';

final teacherHomeLockedNotifierProvider =
    StateNotifierProvider<TeacherLockedHomeNotifier, TeacherLockedHomeStates>(
  (ref) => TeacherLockedHomeNotifier(
    ref: ref,
    teacherHomeRepository: GetIt.I<TeacherHomeRepository>(),
  ),
);

class TeacherLockedHomeNotifier extends StateNotifier<TeacherLockedHomeStates> {
  TeacherLockedHomeNotifier(
      {required this.ref, required this.teacherHomeRepository})
      : super(TeacherLockedHomeInitialState());

  final Ref ref;
  final TeacherHomeRepository teacherHomeRepository;

  Future getPoses() async {
    if (ref.watch(teacherLockedAllPosesProvider).isNotEmpty) {
      return;
    }
    try {
      state = TeacherLockedHomeLoadingState();
      final response = await teacherHomeRepository.getPoses();

      ref.read(teacherLockedAllPosesProvider).addAll(response);

      print("This is the pose name${ref.read(teacherLockedAllPosesProvider)[0].poseName}");
      state = TeacherLockedHomeSuccessfulState();
      print(response);
      return;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = TeacherLockedHomeErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.field}: ${error.messages?.join(", ")}')
            .join("\n");
        state = TeacherLockedHomeErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = TeacherLockedHomeErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = TeacherLockedHomeErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = TeacherLockedHomeErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = TeacherLockedHomeErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = TeacherLockedHomeErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future getYogaStyles() async {
    if (ref.watch(teacherLockedAllYogaStylesProvider).isNotEmpty) {
      return;
    }
    try {
      state = TeacherLockedHomeLoadingState();
      final response = await teacherHomeRepository.getYogaStyles();
      ref.read(teacherLockedAllYogaStylesProvider).addAll(response);

      // print("This is the pose name" + ref.read(allPosesProvider)[0].poseName);
      state = TeacherLockedHomeSuccessfulState();
      print(response);
      return;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = TeacherLockedHomeErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.field}: ${error.messages?.join(", ")}')
            .join("\n");
        state = TeacherLockedHomeErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = TeacherLockedHomeErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = TeacherLockedHomeErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = TeacherLockedHomeErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = TeacherLockedHomeErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = TeacherLockedHomeErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future getYogaGuides() async {
    if (!mounted) return;

    ///The Guides are empty.
    var guidesListLength = ref
        .watch(teacherLockedAllYogaGuidesProvider.notifier)
        .isTeacherLockedAllYogaGuidesEmpty();
    if (guidesListLength == false) {
      print('guidesListLength == false');
      return;
    }
    print('guidesListLength == true? $guidesListLength');
    try {
      state = TeacherLockedHomeLoadingState();
      print("Going In to get getYogaGuides");
      final response = await teacherHomeRepository.getYogaGuides();
      ref
          .read(teacherLockedAllYogaGuidesProvider.notifier)
          .updateResponse(response);
      print("Coming Out from getYogaGuides $response");
      Future.delayed(const Duration(milliseconds: 10));
      state = TeacherLockedHomeSuccessfulState();
      // return;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = TeacherLockedHomeErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.field}: ${error.messages?.join(", ")}')
            .join("\n");
        state = TeacherLockedHomeErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = TeacherLockedHomeErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = TeacherLockedHomeErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = TeacherLockedHomeErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = TeacherLockedHomeErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = TeacherLockedHomeErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future getYogaStyleById({required int id}) async {
    try {
      state = TeacherLockedHomeLoadingState();
      final response = await teacherHomeRepository.getYogaStyleById(id: id);

      state = TeacherLockedHomeSuccessfulState();
      print("STYLE NAME================ ${response.styleName}");
      print("STYLE SHORT DESCRIPTION================ ${response.styleShortDescription}");

      ref.read(styleNameProvider.notifier).state = response.styleName;
      ref.read(styleImageProvider.notifier).state = response.styleImage;
      ref.read(styleShortDescriptionProvider.notifier).state =
          response.styleShortDescription;
      ref.read(styleLongDescriptionProvider.notifier).state =
          response.styleDescription;

      print(
          "SHORT DESCRIPTION ========= ${ref.read(styleShortDescriptionProvider)}");

      return;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = TeacherLockedHomeErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.field}: ${error.messages?.join(", ")}')
            .join("\n");
        state = TeacherLockedHomeErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = TeacherLockedHomeErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = TeacherLockedHomeErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = TeacherLockedHomeErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = TeacherLockedHomeErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = TeacherLockedHomeErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future getPoseById({required int id}) async {
    try {
      state = TeacherLockedHomeLoadingState();
      final response = await teacherHomeRepository.getPoseById(id: id);

      state = TeacherLockedHomeSuccessfulState();
      print("POSE NAME================ ${response.poseName}");
      print("POSE SHORT DESCRIPTION================ ${response.poseName}");

      ref.read(poseNameProvider.notifier).state = response.poseName;
      ref.read(poseImageProvider.notifier).state = response.poseImage;
      ref.read(poseShortDescriptionProvider.notifier).state =
          response.poseShortDescription;
      ref.read(poseLongDescriptionProvider.notifier).state =
          response.poseDescription;

      print("SHORT DESCRIPTION ========= ${ref.read(poseNameProvider)}");
      print("POSE NAME========= ${ref.read(poseShortDescriptionProvider)}");

      return;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = TeacherLockedHomeErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.field}: ${error.messages?.join(", ")}')
            .join("\n");
        state = TeacherLockedHomeErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = TeacherLockedHomeErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = TeacherLockedHomeErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = TeacherLockedHomeErrorState(
          error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = TeacherLockedHomeErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = TeacherLockedHomeErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }
}

final teacherLockedAllPosesProvider = Provider<List<PosesResponseModel>>((ref) {
  return [];
});

final teacherLockedAllYogaStylesProvider =
    Provider<List<YogaStylesResponseModel>>((ref) {
  return [];
});

class HomeGuideResponseController
    extends StateNotifier<HomeGuideResponseModel> {
  HomeGuideResponseController()
      : super(HomeGuideResponseModel(D: [], O: [], P: [], S: [], T: []));

  void updateResponse(HomeGuideResponseModel newResponse) {
    state = newResponse;
  }

  List<Item> getAllItems(HomeGuideResponseModel state) {
    List<Item> allItems = [];
    allItems.addAll(state.D);
    allItems.addAll(state.O);
    allItems.addAll(state.P);
    allItems.addAll(state.S);
    allItems.addAll(state.T);
    return allItems;
  }

  // Check if the provider is empty or has no data
  bool isTeacherLockedAllYogaGuidesEmpty() {
    return state.D.isEmpty &&
        state.O.isEmpty &&
        state.P.isEmpty &&
        state.S.isEmpty &&
        state.T.isEmpty;
  }
}

final teacherLockedAllYogaGuidesProvider =
    StateNotifierProvider<HomeGuideResponseController, HomeGuideResponseModel>(
        (ref) {
  return HomeGuideResponseController();
});
// final teacherLockedAllYogaGuidesProvider =
//     Provider<HomeGuideResponseModel>((ref) {
//   return HomeGuideResponseModel(D: [], O: [], P: [], S: [], T: []);
// });

final styleNameProvider = StateProvider<String>((ref) => "");
final styleImageProvider = StateProvider<String>((ref) => "");
final styleShortDescriptionProvider = StateProvider<String>((ref) => "");
final styleLongDescriptionProvider = StateProvider<String>((ref) => "");

final poseNameProvider = StateProvider<String>((ref) => "");
final poseImageProvider = StateProvider<String>((ref) => "");
final poseShortDescriptionProvider = StateProvider<String>((ref) => "");
final poseLongDescriptionProvider = StateProvider<String>((ref) => "");
