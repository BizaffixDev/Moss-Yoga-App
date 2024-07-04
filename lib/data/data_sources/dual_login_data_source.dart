import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/data_sources/user_local_data_source.dart';
import 'package:moss_yoga/data/models/dual_login_user.dart';
import 'package:moss_yoga/data/models/login_response_model.dart';
import 'package:moss_yoga/data/network/end_points.dart';
import 'package:moss_yoga/data/network/rest_api_client.dart';

abstract class DualLoginDataSource {
  Future<LoginResponseModel> loginWithOneRole(
      {required DualLoginUser dualLoginUser});
}

class DualLoginDataSourceImpl implements DualLoginDataSource {
  DualLoginDataSourceImpl()
      : _restClient = GetIt.instance<ApiService>(),
        _userLocalDataSource = GetIt.instance<UserLocalDataSource>();

  final ApiService _restClient;
  final UserLocalDataSource _userLocalDataSource;

  @override
  Future<LoginResponseModel> loginWithOneRole(
      {required DualLoginUser dualLoginUser}) async {
    final result = await _restClient.post(
      Endpoints.selectRole,
      dualLoginUser,
      // queryParameters: {},
    );
    print('This is the result of Poses List $result');
    final response = LoginResponseModel.fromJson(result.data);
    print('This is the response of user Type ${response.userType}');
    return response;
  }
}
