import 'package:moss_yoga/data/data_sources/guide_data_sources.dart';

import '../models/guideAZResponse.dart';
import '../models/guide_detail_response.dart';
import '../models/pose_detail_response.dart';
import '../models/style_detail_response.dart';
import '../models/yoga_poses_response_model.dart';
import '../models/yoga_styles_response_model.dart';

abstract class GuideRepository {

  Future<List<PosesResponseModel>> getPosesGuide();

  Future<List<YogaStylesResponseModel>> getYogaStylesGuide();
  Future<GuideResponse> getGuide();
  Future<GetStyleDetailsResponse> getYogaStyleDetailsGuide({required int id});
  Future<GetPoseDetailsResponse> getPoseDetailsGuide({required int id});

  Future<GuideDetailResponse> getGuideDetail({required int id, required String type});
}

class GuideRepositoryImpl extends GuideRepository {
  GuideRepositoryImpl(this.guideStudentDataSource);

  final GuideDataSource guideStudentDataSource;


  @override
  Future<GuideResponse> getGuide() {
    return guideStudentDataSource.getGuide();
  }

  @override
  Future<List<PosesResponseModel>> getPosesGuide() {
    return guideStudentDataSource.getPosesGuide();
  }

  @override
  Future<List<YogaStylesResponseModel>> getYogaStylesGuide() {
    return guideStudentDataSource.getYogaStylesGuide();
  }

  @override
  Future<GetPoseDetailsResponse> getPoseDetailsGuide({required int id}) {
    return guideStudentDataSource.getPoseDetailsGuide(id: id);
  }

  @override
  Future<GetStyleDetailsResponse> getYogaStyleDetailsGuide({required int id}) {
    return guideStudentDataSource.getYogaStyleDetailsGuide(id: id);
  }

  @override
  Future<GuideDetailResponse> getGuideDetail({required int id, required String type}) {
    return guideStudentDataSource.getGuideDetail(id: id, type: type);
  }

}

