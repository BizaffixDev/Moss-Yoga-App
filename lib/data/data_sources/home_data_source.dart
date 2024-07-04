import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/data_sources/user_local_data_source.dart';
import 'package:moss_yoga/data/models/add_schedule_teacher_request_model.dart';
import 'package:moss_yoga/data/models/add_schedule_teacher_response_model.dart';
import 'package:moss_yoga/data/models/home_guide_response_model.dart';
import 'package:moss_yoga/data/models/style_detail_response.dart';
import 'package:moss_yoga/data/models/top_rated_teacher_response_model.dart';
import 'package:moss_yoga/data/models/yoga_poses_response_model.dart';
import 'package:moss_yoga/data/models/yoga_styles_response_model.dart';
import 'package:moss_yoga/data/network/end_points.dart';
import 'package:moss_yoga/data/network/rest_api_client.dart';

import '../models/pose_detail_response.dart';
import '../models/pre_booking_session_request_model.dart';
import '../models/pre_booking_session_response_model.dart';
import '../models/reschedule_session_response_model.dart';
import '../models/reshedule_session_request_model.dart';
import '../models/teacher_detail_schedule_response.dart';
import '../models/you_may_also_like_response.dart';

abstract class HomeDataSource {
  Future<List<PosesResponseModel>> getPoses();

  Future<List<YogaStylesResponseModel>> getYogaStyles();

  Future<HomeGuideResponseModel> getYogaGuides();

  Future<List<TopRatedTeacherResponseModel>> getTopRatedTeachers();

  Future<AddScheduleTeacherResponse> addScheduleDateTimeTeachers(
      {required AddScheduleTeacherRequest addScheduleTeacherRequest});

  Future<TeacherDetailScheduleResponse> getTeacherSchedule(
      {required int userId});

  Future<PreBookingSessionResponse> preBookSessionRequest(
      {required PreBookingSessionRequest preBookingSessionRequest});

  Future<GetStyleDetailsResponse> getYogaStyleDetails({required int id});

  Future<GetPoseDetailsResponse> getPoseDetails({required int id});

  Future<YouMayAlsoLikeReponse> getYouMayAlsoLike();

 /* Future<RescheduleSessionResponse> rescheduleSession(
      {required RescheduleSessionRequest rescheduleSessionRequest});*/
}

class HomeDataSourceImpl implements HomeDataSource {
  HomeDataSourceImpl()
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
  Future<HomeGuideResponseModel> getYogaGuides() async {
    final result = await _restClient.get(
      Endpoints.getAllYogaStyles,
      queryParameters: {},
    );
    print('This is the result of Poses List $result');
    final response = HomeGuideResponseModel.fromJson(result.data);
    print('This is the response of YogaGuides List index D ${response.D}');
    return response;
  }

  @override
  Future<List<TopRatedTeacherResponseModel>> getTopRatedTeachers() async {
    final result = await _restClient.get(
      Endpoints.getTopRatedTeachers,
      queryParameters: {},
    );
    print('This is the result of Poses List $result');
    final response =
        topRatedTeacherResponseModelFromJson(json.encode(result.data));
    print('This is the response of decoded List $response');
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
  Future<TeacherDetailScheduleResponse> getTeacherSchedule(
      {required int userId}) async {
    final result = await _restClient.get(
      Endpoints.getTeacherSchedule,
      queryParameters: {
        "userid": userId,
      },
    );
    print('This is the result of teacherDetail$result');
    final response =
        teacherDetailScheduleResponseFromJson(json.encode(result.data));
    print('This is the response of decoded List $response');
    return response;
  }

  @override
  Future<PreBookingSessionResponse> preBookSessionRequest(
      {required PreBookingSessionRequest preBookingSessionRequest}) async {
    try {
      final result = await _restClient.post(
        Endpoints.preBookingSession,
        preBookingSessionRequest,
        //int.parse(jsonDecode(userModel!.userId.toString()).toString()),
        isSignUporLogin: true,
      );

      debugPrint('Student Detail Reqest====== $preBookingSessionRequest');
      debugPrint(
          'Student User ID========  ${preBookingSessionRequest.studentId}');
      if (result.data == null) {
        throw Exception('Empty response');
      }
      final response = PreBookingSessionResponse.fromJson(result.data);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<GetStyleDetailsResponse> getYogaStyleDetails({required int id}) async {
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
  Future<GetPoseDetailsResponse> getPoseDetails({required int id}) async {
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

/*  @override
  Future<RescheduleSessionResponse> rescheduleSession(
      {required RescheduleSessionRequest rescheduleSessionRequest}) async {
    final result = await _restClient.post(
      Endpoints.rescheduleBooking,
      rescheduleSessionRequest,
    );

    debugPrint('This is the result $result');
    debugPrint('Student My Classes Request====== $rescheduleSessionRequest');
    if (result.data == null) {
      throw Exception('Empty response');
    }
    final response = RescheduleSessionResponse.fromJson(result.data);
    debugPrint('This is the response $response');
    return response;
  }*/
}
