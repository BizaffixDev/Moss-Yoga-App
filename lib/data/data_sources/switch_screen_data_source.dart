import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/data_sources/user_local_data_source.dart';
import 'package:moss_yoga/data/models/login_response_model.dart';
import 'package:moss_yoga/data/models/switch_screen_request_model.dart';
import 'package:moss_yoga/data/models/switch_screen_response_model.dart';
import 'package:moss_yoga/data/network/end_points.dart';
import 'package:moss_yoga/data/network/rest_api_client.dart';

abstract class SwithcScreenDataSource {
  Future<LoginResponseModel> switchToTeacher(
      {required SwitchScreenRequestModel switchScreenRequestModel});

  Future<LoginResponseModel> switchToStudent(
      {required SwitchScreenRequestModel switchScreenRequestModel});
}

class SwithcScreenDataSourceImpl implements SwithcScreenDataSource {
  SwithcScreenDataSourceImpl()
      : _restClient = GetIt.instance<ApiService>(),
        _userLocalDataSource = GetIt.instance<UserLocalDataSource>();

  final ApiService _restClient;
  final UserLocalDataSource _userLocalDataSource;

  @override
  Future<LoginResponseModel> switchToTeacher(
      {required SwitchScreenRequestModel switchScreenRequestModel}) async {
    print('Inside switch data source layer sending $switchScreenRequestModel');
    final result = await _restClient.post(
      Endpoints.switchRoles,
      switchScreenRequestModel,
    );
    print('This is the result of switchToTeacher $result');
    final response = LoginResponseModel.fromJson(result.data);
    print('This is the response of switch ${response.userType}');
    return response;
  }

  @override
  Future<LoginResponseModel> switchToStudent(
      {required SwitchScreenRequestModel switchScreenRequestModel}) async {
    print(
        'This is the result of switchToStudent ${switchScreenRequestModel.username}');

    final result = await _restClient.post(
      Endpoints.switchRoles,
      switchScreenRequestModel,
    );
    print('This is the result of switchToStudent $result');
    final response = LoginResponseModel.fromJson(result.data);
    print('This is the response of switchToStudent ${response.userType}');
    print('This is the response of switchToStudent ${response.username}');
    return response;
  }
}
