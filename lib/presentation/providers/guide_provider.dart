import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/models/guide_detail_response.dart';
import 'package:moss_yoga/data/models/style_detail_response.dart';
import 'package:moss_yoga/data/repositories/guide_repository.dart';
import 'package:moss_yoga/presentation/providers/screen_state.dart';
import '../../data/models/guideAZResponse.dart';
import '../../data/models/pose_detail_response.dart';
import '../../data/models/yoga_poses_response_model.dart';
import '../../data/models/yoga_styles_response_model.dart';
import '../../data/network/error_handler_interceptor.dart';
import '../screens/guide/guide_states.dart';

final guideNotifierProvider = StateNotifierProvider<GuideNotifier, GuideStates>(
  (ref) => GuideNotifier(
    ref: ref,
    guideRepository: GetIt.I<GuideRepository>(),
  ),
);

class GuideNotifier extends StateNotifier<GuideStates> {
  GuideNotifier({required this.ref, required this.guideRepository})
      : super(GuideInitialState());

  final Ref ref;
  final GuideRepository guideRepository;

  Future getPosesGuide() async {
    if (ref.watch(allPosesGuideProvider).isNotEmpty) {
      return;
    }
    try {
      state = GuideLoadingState();
      final response = await guideRepository.getPosesGuide();

      ref.read(allPosesGuideProvider).addAll(response);

      print("This is the pose name${ref.read(allPosesGuideProvider)[0].poseName}");
      state = GuideSuccessfulState();
      print(response);
      return;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = GuideErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = GuideErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = GuideErrorState(error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = GuideErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = GuideErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = GuideErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = GuideErrorState(error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future getYogaStylesGuide() async {
    if (ref.watch(allYogaStylesGuideProvider).isNotEmpty) {
      return;
    }
    try {
      state = GuideLoadingState();
      final response = await guideRepository.getYogaStylesGuide();
      ref.read(allYogaStylesGuideProvider).addAll(response);

      // print("This is the pose name" + ref.read(allPosesProvider)[0].poseName);
      state = GuideSuccessfulState();
      print(response);
      return;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = GuideErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = GuideErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = GuideErrorState(error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = GuideErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = GuideErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = GuideErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = GuideErrorState(error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future getGuideData() async {

    try {

      state = GuideLoadingState();
      final response = await guideRepository.getGuide();
      ref.read(guideListProvider.notifier).state = response; // Update the state here
      state = GuideSuccessfulState();

    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = GuideErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = GuideErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = GuideErrorState(error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = GuideErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = GuideErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = GuideErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = GuideErrorState(error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future getPoseDetailsGuide({required int id}) async {
    try {
      state = GuidePoseLoadingState();
      final response = await guideRepository.getPoseDetailsGuide(id: id);

      state = GuidePoseSuccessfulState();
      print("POSE NAME================ ${response.poseName}");
      print("POSE SHORT DESCRIPTION================ ${response.poseName}");

      ref.read(poseNameProvider.notifier).state = response.poseName;
      ref.read(poseImageProvider.notifier).state = response.poseImage;
      ref.read(poseShortDescriptionProvider.notifier).state =
          response.poseShortDescription;
      ref
          .read(poseLongDescriptionProvider.notifier)
          .state
          .addAll(response.detailDescription);

      /*ref.read(poseHeading1Provider.notifier).state =
          response.detailDescription[0].header;
      ref.read(poseDetail1Provider.notifier).state =
          response.detailDescription[0].detail;
      ref.read(poseHeading2Provider.notifier).state =
          response.detailDescription[1].header;
      ref.read(poseDetail2Provider.notifier).state =
          response.detailDescription[1].detail;
      ref.read(poseHeading3Provider.notifier).state =
          response.detailDescription[2].header;
      ref.read(poseDetail3Provider.notifier).state =
          response.detailDescription[2].detail;*/

      ref.read(poseDetailProvider.notifier).state = response.detailDescription;

      print("SHORT DESCRIPTION ========= ${ref.read(poseNameProvider)}");
      print("POSE NAME========= ${ref.read(poseShortDescriptionProvider)}");
      print(
          "POSE DETAIL DESCRIPTION========= ${ref.read(poseLongDescriptionProvider)}");

      return;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = GuidePoseErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.messages}: ${error.messages?.join(", ")}')
            .join("\n");
        state = GuidePoseErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state =
            GuidePoseErrorState(error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state =
            GuidePoseErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state = GuidePoseErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = GuidePoseErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state =
          GuidePoseErrorState(error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future getYogaStyleDetailsGuide({required int id}) async {
    try {
      state = GuideStyleLoadingState();
      final response = await guideRepository.getYogaStyleDetailsGuide(id: id);

      state = GuideStyleSuccessfulState();
      print("STYLE NAME================ ${response.styleName}");
      print("STYLE SHORT DESCRIPTION================ ${response.styleShortDescription}");

      ref.read(styleNameProvider.notifier).state = response.styleName;
      ref.read(styleImageProvider.notifier).state = response.styleImage;
      ref.read(styleShortDescriptionProvider.notifier).state =
          response.styleShortDescription;
      ref
          .read(styleLongDescriptionProvider.notifier)
          .state
          .addAll(response.detailDescription);

      ref.read(styleDetailProvider.notifier).state = response.detailDescription;

      print(
          "SHORT DESCRIPTION ========= ${ref.read(styleShortDescriptionProvider)}");

      return;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = GuideStyleErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = GuideStyleErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state =
            GuideStyleErrorState(error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state =
            GuideStyleErrorState(error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state =
          GuideStyleErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = GuideStyleErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state =
          GuideStyleErrorState(error: e.toString(), errorType: ErrorType.other);
    }
  }

  Future getGuideDetailsAZ({required int id, required String type}) async {
    try {
      state = GuideDetailAZLoadingState();
      final response = await guideRepository.getGuideDetail(id: id, type: type);

      state = GuideDetailAZSuccessfulState();
      print("GUIDENAME================ ${response.name}");
      print("Guide SHORT DESCRIPTION================ ${response.shortDescription}");

      ref.read(guideNameProvider.notifier).state = response.name;
      ref.read(guideImageProvider.notifier).state = response.image;
      ref.read(guideShortDescriptionProvider.notifier).state =
          response.shortDescription;
      // ref
      //     .read(guideLongDescriptionProvider.notifier)
      //     .state
      //     .addAll(response.detailDescription);
      // ref.read(guideHeading1Provider.notifier).state =
      //     response.detailDescription[0].header;
      // ref.read(guideDetail1Provider.notifier).state =
      //     response.detailDescription[0].detail;
      // ref.read(guideHeading2Provider.notifier).state =
      //     response.detailDescription[1].header;
      // ref.read(guideDetail2Provider.notifier).state =
      //     response.detailDescription[1].detail;
      // ref.read(guideHeading3Provider.notifier).state =
      //     response.detailDescription[2].header;
      // ref.read(guideDetail3Provider.notifier).state =
      //     response.detailDescription[2].detail;

      ref
          .read(guideLongDescriptionProvider.notifier)
          .state
          .addAll(response.detailDescription);

      ref.read(guideAZDetailProvider.notifier).state = response.detailDescription;

      return;
    } on UnauthorizedException catch (e) {
      print('This is the unauthorized part');
      state = GuideDetailAZErrorState(
          error: e.errorText.toString(), errorType: ErrorType.inline);
    } on BackendResponseError catch (e) {
      if (e.statusCode == 400) {
        // Handle the 400 error scenario
        // Access the errors from the responseErrors property of the BackendResponseError
        final responseErrors = e.responseErrors;
        final errorMessages = responseErrors
            .map((error) => '${error.message}: ${error.messages?.join(", ")}')
            .join("\n");
        state = GuideDetailAZErrorState(
            error: errorMessages.toString(), errorType: ErrorType.inline);
      } else if (e.statusCode == 422) {
        print('going inside this BackendResponseError block bro');

        state = GuideDetailAZErrorState(
            error: e.message, errorType: ErrorType.inline);
      } else {
        print('I guess it should be here');
        state = GuideDetailAZErrorState(
            error: e.message, errorType: ErrorType.other);
      }
    } on NoInternetConnectionException catch (e) {
      print('going inside this NoInternetConnectionException block bro');
      state =
          GuideDetailAZErrorState(error: e.message, errorType: ErrorType.other);
    } on DioError catch (e) {
      print('going inside this DioError block bro');
      print("This is e.response ${e.response}");
      if (e.response?.statusCode == 400) {
        state = GuideDetailAZErrorState(
            error: e.response!.data.toString(), errorType: ErrorType.other);
      }
      if (e.response != null) {
        final errorResponse = e.response!.data;
        final title = errorResponse['title'];
        print('ERROR RESPONSE: $errorResponse');
        print('Title: $title');
      }
      print(e.toString());
      state = GuideDetailAZErrorState(
          error: e.toString(), errorType: ErrorType.other);
    }
  }


}

final allPosesGuideProvider = Provider<List<PosesResponseModel>>((ref) {
  return [];
});

final allYogaStylesGuideProvider =
    Provider<List<YogaStylesResponseModel>>((ref) {
  return [];
});

final guideListProvider = StateProvider<GuideResponse>((ref) {
  return GuideResponse(guideMap: {});
});




final guideNameProvider = StateProvider.autoDispose<String>((ref) => "");
final guideImageProvider = StateProvider.autoDispose<String>((ref) => "");
final guideShortDescriptionProvider = StateProvider.autoDispose<String>((ref) => "");
final guideLongDescriptionProvider = StateProvider.autoDispose<List>((ref) => []);
final guideHeading1Provider = StateProvider<String>((ref) => "");
final guideDetail1Provider = StateProvider<String>((ref) => "");
final guideHeading2Provider = StateProvider<String>((ref) => "");
final guideDetail2Provider = StateProvider<String>((ref) => "");
final guideHeading3Provider = StateProvider<String>((ref) => "");
final guideDetail3Provider = StateProvider<String>((ref) => "");

final styleNameProvider = StateProvider.autoDispose<String>((ref) => "");
final styleImageProvider = StateProvider.autoDispose<String>((ref) => "");
final styleShortDescriptionProvider = StateProvider.autoDispose<String>((ref) => "");
final styleLongDescriptionProvider = StateProvider.autoDispose<List>((ref) => []);
// final styleHeading1Provider = StateProvider<String>((ref) => "");
// final styleDetail1Provider = StateProvider<String>((ref) => "");
// final styleHeading2Provider = StateProvider<String>((ref) => "");
// final styleDetail2Provider = StateProvider<String>((ref) => "");
// final styleHeading3Provider = StateProvider<String>((ref) => "");
// final styleDetail3Provider = StateProvider<String>((ref) => "");

final poseNameProvider = StateProvider.autoDispose<String>((ref) => "");
final poseImageProvider = StateProvider.autoDispose<String>((ref) => "");
final poseShortDescriptionProvider = StateProvider.autoDispose<String>((ref) => "");
final poseLongDescriptionProvider = StateProvider.autoDispose<List>((ref) => []);
// final poseHeading1Provider = StateProvider<String>((ref) => "");
// final poseDetail1Provider = StateProvider<String>((ref) => "");
// final poseHeading2Provider = StateProvider<String>((ref) => "");
// final poseDetail2Provider = StateProvider<String>((ref) => "");
// final poseHeading3Provider = StateProvider<String>((ref) => "");
// final poseDetail3Provider = StateProvider<String>((ref) => "");



final poseDetailProvider = StateProvider.autoDispose<List<PoseDetailDescription>>((ref) => []);
final styleDetailProvider = StateProvider.autoDispose<List<StyleDetailDescription>>((ref) => []);
final guideAZDetailProvider = StateProvider.autoDispose<List<GuideAZDetailDescription>>((ref) => []);
