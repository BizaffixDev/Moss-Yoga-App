import 'package:moss_yoga/data/data_sources/home_data_source.dart';
import 'package:moss_yoga/data/models/home_guide_response_model.dart';
import 'package:moss_yoga/data/models/pose_detail_response.dart';
import 'package:moss_yoga/data/models/pre_booking_session_response_model.dart';
import 'package:moss_yoga/data/models/top_rated_teacher_response_model.dart';
import 'package:moss_yoga/data/models/yoga_poses_response_model.dart';
import 'package:moss_yoga/data/models/yoga_styles_response_model.dart';

import '../models/add_schedule_teacher_request_model.dart';
import '../models/add_schedule_teacher_response_model.dart';
import '../models/pre_booking_session_request_model.dart';
import '../models/reschedule_session_response_model.dart';
import '../models/reshedule_session_request_model.dart';
import '../models/style_detail_response.dart';
import '../models/teacher_detail_schedule_response.dart';
import '../models/you_may_also_like_response.dart';

abstract class HomeRepository {
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

  // Future<RescheduleSessionResponse> rescheduleSession({required RescheduleSessionRequest rescheduleSessionRequest});
}

class HomeRepositoryImpl extends HomeRepository {
  HomeRepositoryImpl(this.homeDataSource);

  final HomeDataSource homeDataSource;

  @override
  Future<List<PosesResponseModel>> getPoses() {
    return homeDataSource.getPoses();
  }

  @override
  Future<List<YogaStylesResponseModel>> getYogaStyles() {
    return homeDataSource.getYogaStyles();
  }

  @override
  Future<HomeGuideResponseModel> getYogaGuides() {
    return homeDataSource.getYogaGuides();
  }

  @override
  Future<List<TopRatedTeacherResponseModel>> getTopRatedTeachers() {
    return homeDataSource.getTopRatedTeachers();
  }

  @override
  Future<AddScheduleTeacherResponse> addScheduleDateTimeTeachers(
      {required AddScheduleTeacherRequest addScheduleTeacherRequest}) {
    return homeDataSource.addScheduleDateTimeTeachers(
        addScheduleTeacherRequest: addScheduleTeacherRequest);
  }

  @override
  Future<TeacherDetailScheduleResponse> getTeacherSchedule(
      {required int userId}) {
    return homeDataSource.getTeacherSchedule(userId: userId);
  }

  @override
  Future<PreBookingSessionResponse> preBookSessionRequest(
      {required PreBookingSessionRequest preBookingSessionRequest}) {
    return homeDataSource.preBookSessionRequest(
        preBookingSessionRequest: preBookingSessionRequest);
  }

  @override
  Future<GetStyleDetailsResponse> getYogaStyleDetails({required int id}) {
    return homeDataSource.getYogaStyleDetails(id: id);
  }

  @override
  Future<GetPoseDetailsResponse> getPoseDetails({required int id}) {
    return homeDataSource.getPoseDetails(id: id);
  }

  @override
  Future<YouMayAlsoLikeReponse> getYouMayAlsoLike() {
    return homeDataSource.getYouMayAlsoLike();
  }

  // @override
  // Future<RescheduleSessionResponse> rescheduleSession({required rescheduleSessionRequest}) {
  //   return homeDataSource.rescheduleSession(rescheduleSessionRequest: rescheduleSessionRequest);
  // }


}
