import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/data_sources/user_local_data_source.dart';
import 'package:moss_yoga/data/models/add_schedule_teacher_request_model.dart';
import 'package:moss_yoga/data/models/add_schedule_teacher_response_model.dart';
import 'package:moss_yoga/data/models/get_teacher_no_of_session_response_model.dart';
import 'package:moss_yoga/data/models/get_teacher_online_ondemand_response_model.dart';
import 'package:moss_yoga/data/models/home_guide_response_model.dart';
import 'package:moss_yoga/data/models/pose_detail_response.dart';
import 'package:moss_yoga/data/models/style_detail_response.dart';
import 'package:moss_yoga/data/models/teacher_online_status_request_model.dart';
import 'package:moss_yoga/data/models/teacher_online_status_response_model.dart';
import 'package:moss_yoga/data/models/upcoming_classes_home_response_model.dart';
import 'package:moss_yoga/data/models/yoga_poses_response_model.dart';
import 'package:moss_yoga/data/models/yoga_styles_response_model.dart';
import 'package:moss_yoga/data/network/end_points.dart';
import 'package:moss_yoga/data/network/rest_api_client.dart';

import '../../models/you_may_also_like_response.dart';

abstract class TeacherHomeDataSource {
  Future<GetTeacherNoOfSessionResponseModel> getNoOfSessions({required int id});

  Future<List<PosesResponseModel>> getPoses();

  Future<List<YogaStylesResponseModel>> getYogaStyles();

  Future<TeacherOnlineStatusResponseModel> changeOnlineStatusForTeacher(
      {required bool value});

  Future<AddScheduleTeacherResponse> addScheduleDateTimeTeachers(
      {required AddScheduleTeacherRequest addScheduleTeacherRequest});

  Future<GetStyleDetailsResponse> getYogaStyleById({required int id});

  Future<GetPoseDetailsResponse> getPoseById({required int id});

  Future<UpcomingClassesHomeReponse> getUpcomingClasses({required int id});

  Future<HomeGuideResponseModel> getYogaGuides();

  Future<YouMayAlsoLikeReponse> getYouMayAlsoLike();

  Future<GetTeacherOndemandOnlineResponseModel> getOnlineStatusForTeacher(
      {required String teacherId});
}

class TeacherHomeDataSourceImpl implements TeacherHomeDataSource {
  TeacherHomeDataSourceImpl()
      : _restClient = GetIt.instance<ApiService>(),
        _userLocalDataSource = GetIt.instance<UserLocalDataSource>();

  final ApiService _restClient;
  final UserLocalDataSource _userLocalDataSource;

  @override
  Future<List<PosesResponseModel>> getPoses() async {
    final result = await _restClient.get(
      Endpoints.getAllPoses,
      queryParameters: {},
    );
    print('This is the result of Poses List $result');
    final response = PosesListModel.fromJson(result.data);
    print('This is the response of decoded List ${response.poses}');
    return response.poses;
  }

  @override
  Future<List<YogaStylesResponseModel>> getYogaStyles() async {
    final result = await _restClient.get(
      Endpoints.getAllYogaStyles,
      queryParameters: {},
    );
    print('This is the result of Poses List $result');
    final response = YogaStylesListModel.fromJson(result.data);
    print('This is the response of decoded List ${response.styles}');
    return response.styles;
  }

  @override
  Future<TeacherOnlineStatusResponseModel> changeOnlineStatusForTeacher(
      {required bool value}) async {
    final user = await _userLocalDataSource.getUser();
    final TeacherOnlineStatusRequestModel teacherOnlineStatusRequestModel =
        TeacherOnlineStatusRequestModel(
            userId: user!.userId, onlineStatus: value);
    print(user.email);
    print(
        "This is the request model going ${teacherOnlineStatusRequestModel.userId}");
    final result = await _restClient.patch(
      Endpoints.changeOnlineStatusForTeacher,
      teacherOnlineStatusRequestModel,
    );
    print('This is the result of changeOnlineStatusForTeacher ${result.data}');
    final response = TeacherOnlineStatusResponseModel.fromJson(result.data);
    print('This is the response changeOnlineStatusForTeacher $response');
    return response;
  }

  @override
  Future<AddScheduleTeacherResponse> addScheduleDateTimeTeachers(
      {required AddScheduleTeacherRequest addScheduleTeacherRequest}) async {
    try {
      final result = await _restClient.post(
        Endpoints.addSchedule,
        addScheduleTeacherRequest,
        isSignUporLogin: true,
      );

      print('Schedule Detail Reqest====== $addScheduleTeacherRequest');

      if (result.data == null) {
        throw Exception('Empty response');
      }
      final response = AddScheduleTeacherResponse.fromJson(result.data);

      print("SCHEDULE RESPONSE $response");

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<GetStyleDetailsResponse> getYogaStyleById({required int id}) async {
    final result = await _restClient.get(
      Endpoints.getStyleDetails,
      queryParameters: {
        "id": id,
      },
    );
    print('This is the result of getStylebyID $result');
    final response = getStyleDetailsResponseFromJson(json.encode(result.data));
    print('This is the response of decoded List $response');
    return response;
  }

  @override
  Future<GetPoseDetailsResponse> getPoseById({required int id}) async {
    final result = await _restClient.get(
      Endpoints.getPoseDetails,
      queryParameters: {
        "id": id,
      },
    );
    print('This is the result of getPoseByID $result');
    final response = getPoseDetailsResponseFromJson(json.encode(result.data));
    print('This is the response of decoded List $response');
    return response;
  }

  @override
  Future<HomeGuideResponseModel> getYogaGuides() async {
    final result = await _restClient.get(
      Endpoints.guide,
      queryParameters: {},
    );
    print('This is the result of Poses List $result');
    final response = HomeGuideResponseModel.fromJson(result.data);
    print('This is the response of YogaGuides List index D ${response.D}');
    return response;
  }

  @override
  Future<UpcomingClassesHomeReponse> getUpcomingClasses(
      {required int id}) async {
    final result = await _restClient.get(
      Endpoints.upComingClassesHome,
      queryParameters: {
        "TeacherId": id,
      },
    );
    print('This is the result of getPoseByID $result');
    final response =
        upcomingClassesHomeReponseFromJson(json.encode(result.data));
    print('This is the response of decoded List $response');
    return response;
  }

  @override
  Future<GetTeacherNoOfSessionResponseModel> getNoOfSessions(
      {required int id}) async {
    final result = await _restClient.get(
      Endpoints.getNoOfSessions,
      queryParameters: {
        // "TeacherId": id,
      },
    );
    print('This is the result of getNoOfSessions $result');
    final response = GetTeacherNoOfSessionResponseModel.fromJson(result.data);
    print('This is the response of decoded List $response');
    return response;
  }

  @override
  Future<YouMayAlsoLikeReponse> getYouMayAlsoLike() async {
    final result = await _restClient.get(
      Endpoints.youMayLike,
      queryParameters: {},
    );
    print('This is the result of you may also like ${result}');
    final response = youMayAlsoLikeReponseFromJson(json.encode(result.data));
    print('This is the response of decoded List ${response}');
    return response;
  }

  @override
  Future<GetTeacherOndemandOnlineResponseModel> getOnlineStatusForTeacher(
      {required String teacherId}) async {
    final result = await _restClient.get(
      Endpoints.getOnlineStatusForTeacher,
      queryParameters: {"teacherId": teacherId.toString()},
    );
    print('This is the result of getOnlineStatusForTeacher ${result.data}');
    final response =
        GetTeacherOndemandOnlineResponseModel.fromJson(result.data);
    print('This is the response changeOnlineStatusForTeacher $response');
    return response;
  }
}
