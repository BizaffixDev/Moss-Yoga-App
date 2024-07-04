import 'package:moss_yoga/data/data_sources/firebase_messaging_data_source.dart';
import 'package:moss_yoga/data/models/yoga_poses_response_model.dart';

abstract class FirebaseMessagingRepository {
  Future<List<PosesResponseModel>> saveTokenOnBackEnd();

  Future<void> saveTokenOnSharedPrefs({required String token});
}

class FirebaseMessagingRepositoryImpl extends FirebaseMessagingRepository {
  FirebaseMessagingRepositoryImpl(this.firebaseMessagingDataSource);

  final FirebaseMessagingDataSource firebaseMessagingDataSource;

  @override
  Future<List<PosesResponseModel>> saveTokenOnBackEnd() {
    return firebaseMessagingDataSource.saveTokenOnBackEnd();
  }

  @override
  Future<void> saveTokenOnSharedPrefs({required String token}) {
    return firebaseMessagingDataSource.saveTokenOnSharedPrefs(token: token);
  }
}
