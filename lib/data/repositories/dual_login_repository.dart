import 'package:moss_yoga/data/data_sources/dual_login_data_source.dart';
import 'package:moss_yoga/data/models/dual_login_user.dart';
import 'package:moss_yoga/data/models/login_response_model.dart';

abstract class DualLoginRepository {
  Future<LoginResponseModel> loginWithOneRole(
      {required DualLoginUser dualLoginUser});
}

class DualLoginRepositoryImpl extends DualLoginRepository {
  DualLoginRepositoryImpl(this.dualLoginDataSource);

  final DualLoginDataSource dualLoginDataSource;

  @override
  Future<LoginResponseModel> loginWithOneRole(
      {required DualLoginUser dualLoginUser}) {
    return dualLoginDataSource.loginWithOneRole(dualLoginUser: dualLoginUser);
  }
}
