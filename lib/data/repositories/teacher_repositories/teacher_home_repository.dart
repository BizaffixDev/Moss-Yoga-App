import 'package:moss_yoga/data/data_sources/teacher_data_sources/teacher_home_data_sources.dart';
import 'package:moss_yoga/data/models/get_teacher_no_of_session_response_model.dart';
import 'package:moss_yoga/data/models/get_teacher_online_ondemand_response_model.dart';
import 'package:moss_yoga/data/models/home_guide_response_model.dart';
import 'package:moss_yoga/data/models/pose_detail_response.dart';
import 'package:moss_yoga/data/models/style_detail_response.dart';
import 'package:moss_yoga/data/models/teacher_online_status_response_model.dart';
import 'package:moss_yoga/data/models/yoga_poses_response_model.dart';
import 'package:moss_yoga/data/models/yoga_styles_response_model.dart';

import '../../models/add_schedule_teacher_request_model.dart';
import '../../models/add_schedule_teacher_response_model.dart';
import '../../models/upcoming_classes_home_response_model.dart';
import '../../models/you_may_also_like_response.dart';

abstract class TeacherHomeRepository {
  Future<GetTeacherNoOfSessionResponseModel> getNoOfSessions({required int id});

  Future<List<PosesResponseModel>> getPoses();

  Future<List<YogaStylesResponseModel>> getYogaStyles();

  Future<TeacherOnlineStatusResponseModel> changeOnlineStatusForTeacher(
      {required bool value});

  Future<GetTeacherOndemandOnlineResponseModel> getOnlineStatusForTeacher(
      {required String teacherId});

  Future<GetStyleDetailsResponse> getYogaStyleById({required int id});

  Future<GetPoseDetailsResponse> getPoseById({required int id});

  Future<AddScheduleTeacherResponse> addScheduleDateTimeTeachers(
      {required AddScheduleTeacherRequest addScheduleTeacherRequest});

  Future<HomeGuideResponseModel> getYogaGuides();

  Future<UpcomingClassesHomeReponse> getUpcomingClasses({required int id});

  Future<YouMayAlsoLikeReponse> getYouMayAlsoLike();
}

class TeacherHomeRepositoryImpl extends TeacherHomeRepository {
  TeacherHomeRepositoryImpl(this.teacherHomeDataSource);

  final TeacherHomeDataSource teacherHomeDataSource;

  @override
  Future<List<PosesResponseModel>> getPoses() {
    return teacherHomeDataSource.getPoses();
  }

  @override
  Future<List<YogaStylesResponseModel>> getYogaStyles() {
    return teacherHomeDataSource.getYogaStyles();
  }

  @override
  Future<TeacherOnlineStatusResponseModel> changeOnlineStatusForTeacher(
      {required bool value}) {
    return teacherHomeDataSource.changeOnlineStatusForTeacher(value: value);
  }

  @override
  Future<GetStyleDetailsResponse> getYogaStyleById({required int id}) {
    return teacherHomeDataSource.getYogaStyleById(id: id);
  }

  @override
  Future<GetPoseDetailsResponse> getPoseById({required int id}) {
    return teacherHomeDataSource.getPoseById(id: id);
  }

  @override
  Future<AddScheduleTeacherResponse> addScheduleDateTimeTeachers(
      {required AddScheduleTeacherRequest addScheduleTeacherRequest}) async {
    return teacherHomeDataSource.addScheduleDateTimeTeachers(
        addScheduleTeacherRequest: addScheduleTeacherRequest);
  }

  @override
  Future<HomeGuideResponseModel> getYogaGuides() {
    return teacherHomeDataSource.getYogaGuides();
  }

  @override
  Future<UpcomingClassesHomeReponse> getUpcomingClasses({required int id}) {
    return teacherHomeDataSource.getUpcomingClasses(id: id);
  }

  @override
  Future<GetTeacherNoOfSessionResponseModel> getNoOfSessions(
      {required int id}) {
    return teacherHomeDataSource.getNoOfSessions(id: id);
  }

  @override
  Future<YouMayAlsoLikeReponse> getYouMayAlsoLike() {
    return teacherHomeDataSource.getYouMayAlsoLike();
  }

  @override
  Future<GetTeacherOndemandOnlineResponseModel> getOnlineStatusForTeacher(
      {required String teacherId}) {
    return teacherHomeDataSource.getOnlineStatusForTeacher(
        teacherId: teacherId);
  }
}
