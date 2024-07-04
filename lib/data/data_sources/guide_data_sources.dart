import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/models/guide_detail_response.dart';

import '../data_sources/user_local_data_source.dart';
import '../models/guideAZResponse.dart';
import '../models/pose_detail_response.dart';
import '../models/style_detail_response.dart';
import '../models/yoga_poses_response_model.dart';
import '../models/yoga_styles_response_model.dart';
import '../network/end_points.dart';
import '../network/rest_api_client.dart';

abstract class GuideDataSource {
  Future<List<PosesResponseModel>> getPosesGuide();

  Future<List<YogaStylesResponseModel>> getYogaStylesGuide();


  Future<GuideResponse> getGuide();



  Future<GetStyleDetailsResponse> getYogaStyleDetailsGuide({required int id});

  Future<GetPoseDetailsResponse> getPoseDetailsGuide({required int id});

  Future<GuideDetailResponse> getGuideDetail({required int id, required String type});


}



class GuideDataSourceImpl implements GuideDataSource {
  GuideDataSourceImpl()
      : _restClient = GetIt.instance<ApiService>(),
        _userLocalDataSource = GetIt.instance<UserLocalDataSource>();

  final ApiService _restClient;
  final UserLocalDataSource _userLocalDataSource;



  @override
  Future<GuideResponse> getGuide() async{

    final result = await _restClient.get(
      Endpoints.guide,
      queryParameters: {},
    );

    final response = GuideResponse.fromJson(result.data);
    return response;

    // final result = await _restClient.get(
    //   Endpoints.guide,
    //   queryParameters: {},
    // );
    // print('This is the result of guide List $result');
    // final response = KeyGuide.fromJson(result.data);
    // print('This is the response of decoded List $response');
    // return response;
  }

  @override
  Future<List<PosesResponseModel>> getPosesGuide() async{
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
  Future<List<YogaStylesResponseModel>> getYogaStylesGuide() async{
    final result = await _restClient.get(
      Endpoints.getAllYogaStyles,
      queryParameters: {},
    );
    print('This is the result of Styles List $result');
    final response = YogaStylesListModel.fromJson(result.data);
    print('This is the response of decoded List ${response.styles}');
    return response.styles;
  }

  @override
  Future<GuideDetailResponse> getGuideDetail({required int id, required String type}) async {
    final result = await _restClient.get(
      Endpoints.guideDetail,
      queryParameters: {
        "id": id,
        "type":type,
      },
    );
    print('This is the result of getStylebyID $result');
    final response = guideDetailResponseFromJson(json.encode(result.data));
    print('This is the response of decoded List $response');
    return response;
  }

  @override
  Future<GetPoseDetailsResponse> getPoseDetailsGuide({required int id}) async{
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
  Future<GetStyleDetailsResponse> getYogaStyleDetailsGuide({required int id}) async{
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






}