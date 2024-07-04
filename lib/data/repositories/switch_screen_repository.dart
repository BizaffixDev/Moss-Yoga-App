import 'package:moss_yoga/data/data_sources/switch_screen_data_source.dart';
import 'package:moss_yoga/data/models/login_response_model.dart';
import 'package:moss_yoga/data/models/switch_screen_request_model.dart';
import 'package:moss_yoga/data/models/switch_screen_response_model.dart';

abstract class SwitchScreenRepository {
  Future<LoginResponseModel> switchToTeacher(
      {required SwitchScreenRequestModel switchScreenRequestModel});

  Future<LoginResponseModel> switchToStudent(
      {required SwitchScreenRequestModel switchScreenRequestModel});
}

class SwitchScreenRepositoryImpl extends SwitchScreenRepository {
  SwitchScreenRepositoryImpl(this.switchDataSource);

  final SwithcScreenDataSource switchDataSource;

  @override
  Future<LoginResponseModel> switchToTeacher(
      {required SwitchScreenRequestModel switchScreenRequestModel}) {
    return switchDataSource.switchToTeacher(
        switchScreenRequestModel: switchScreenRequestModel);
  }

  @override
  Future<LoginResponseModel> switchToStudent(
      {required SwitchScreenRequestModel switchScreenRequestModel}) {
    return switchDataSource.switchToStudent(
        switchScreenRequestModel: switchScreenRequestModel);
  }
}
