import 'dart:convert';
import 'package:moss_yoga/app/utils/preference_manager.dart';
import 'package:moss_yoga/data/models/login_response_model.dart';

abstract class UserLocalDataSource {
  Future<void> persistUser(LoginResponseModel user);

  Future<LoginResponseModel?> getUser();

  Future<void> deleteUser();

  Future<void> saveFCMDeviceToken({required String token});

  Future<String> getFCMDeviceToken();
// Future<void> saveUserCredentials(UserCredentials userCredentials);
// Future<UserCredentials?> fetchUserCredentials();
// Future<void> delUserCredentials();
// Future<void> saveMobileAndPassword(RegisterRequest registerRequest);
// Future<RegisterRequest?> getMobileAndPassword();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  UserLocalDataSourceImpl({required this.preferencesManager});

  final SecurePreferencesManager preferencesManager;

  final _userKey = 'user_response';
  final _userCredentialsKey = 'user_auth_credentials';
  final _userFcmKey = 'fcm_key';
  final _userMobileAndPasswordKey = 'user_mobile_password';

  @override
  Future<void> persistUser(LoginResponseModel user) async {
    return preferencesManager.store(
      _userKey,
      jsonEncode(user),
      // jsonEncode(user.toJson()),
    );
  }

  @override
  Future<void> deleteUser() async {
    return preferencesManager.remove(_userKey);
  }

  @override
  Future<void> delUserCredentials() async {
    await preferencesManager.remove(_userCredentialsKey);
  }

  @override
  Future<LoginResponseModel?> getUser() async {
    final userJson = await preferencesManager.retrieve(_userKey);
    if (userJson == null || userJson.isEmpty) {
      return null;
    }
    final user = LoginResponseModel.fromJson(jsonDecode(userJson));
    return user;
  }

  @override
  Future<void> saveFCMDeviceToken({required String token}) {
    print('saving this token $token');
    return preferencesManager.store(_userFcmKey, jsonEncode(token));
  }

  @override
  Future<String> getFCMDeviceToken() async {
    final userJson = await preferencesManager.retrieve(_userFcmKey);
    if (userJson == null || userJson.isEmpty) {
      return '';
    }
    final fcmToken = jsonDecode(userJson);
    print('this is the fcmToken $fcmToken');
    return fcmToken;
  }
}
