
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/data_sources/user_local_data_source.dart';
import 'package:moss_yoga/data/models/yoga_poses_response_model.dart';
import 'package:moss_yoga/data/network/end_points.dart';
import 'package:moss_yoga/data/network/rest_api_client.dart';


abstract class FirebaseMessagingDataSource {
  Future<List<PosesResponseModel>> saveTokenOnBackEnd();

  Future<void> saveTokenOnSharedPrefs({required String token});
}

class FirebaseMessagingDataSourceImpl implements FirebaseMessagingDataSource {
  FirebaseMessagingDataSourceImpl()
      : _restClient = GetIt.instance<ApiService>(),
        _userLocalDataSource = GetIt.instance<UserLocalDataSource>();

  final ApiService _restClient;
  final UserLocalDataSource _userLocalDataSource;

  @override
  Future<List<PosesResponseModel>> saveTokenOnBackEnd() async {
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
  Future<void> saveTokenOnSharedPrefs({required String token}) async {
    // var token = await _userLocalDataSource.getFCMDeviceToken();
    // print('testing and getting token first DIS DA TOKEN ${token.toString()}');
    return await _userLocalDataSource.saveFCMDeviceToken(token: token);
  }
}
