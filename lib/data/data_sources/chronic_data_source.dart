import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/models/chronic_response_model.dart';
import '../network/end_points.dart';
import '../network/rest_api_client.dart';

abstract class ChronicDataSource {
  Future<List<ChronicResponseModel>> getChronicConditionList();
}

class ChronicDataSourceImpl implements ChronicDataSource {
  ChronicDataSourceImpl() : _restClient = GetIt.instance<ApiService>();

  final ApiService _restClient;

  @override
  Future<List<ChronicResponseModel>> getChronicConditionList() async {
    try {
      var headers = {'accept': '*/*'};

      final result = await _restClient.get(
        Endpoints.chronicList,
        queryParameters: {},
        options: Options(
          headers: headers,
        ),
      );

      final response = ChronicListResponse.fromJson(result.data);
      //[ChronicResponseModel.fromJson(result.data)];

      print(
          "Chronic data source + ${response.chronicList[0].chronicConditionId}");

      return response.chronicList;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
