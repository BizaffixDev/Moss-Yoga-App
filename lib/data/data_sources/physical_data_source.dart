import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/models/physical_response_model.dart';

import '../network/end_points.dart';
import '../network/rest_api_client.dart';

abstract class PhysicalDataSource {
  Future<List<PhysicalResponseModel>> getPhyscialConditionList();
}

class PhysicalDataSourceImpl implements PhysicalDataSource{

  PhysicalDataSourceImpl()    : _restClient =GetIt.instance<ApiService>();

  final ApiService _restClient;



  @override
  Future<List<PhysicalResponseModel>> getPhyscialConditionList() async{
    try{
      var headers = {
        'accept': '*/*'
      };

      final result = await _restClient.get(
        Endpoints.physicalList, queryParameters: {}, options: Options(
        headers: headers,
      ),);

      final response = PhysicalListResponse.fromJson(result.data);
      //[ChronicResponseModel.fromJson(result.data)];

      print("Physical data source + ${response.physicalList[0].injuryName}");

      return response.physicalList;

    }catch(e){
      print(e.toString());
      rethrow;
    }
  }

}