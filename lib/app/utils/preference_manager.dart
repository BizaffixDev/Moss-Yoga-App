import 'package:flutter_keychain/flutter_keychain.dart';

class SecurePreferencesManager {
  SecurePreferencesManager();

  Future<void> store(String key, String value) async =>
      FlutterKeychain.put(key: key, value: value);

  Future<String?> retrieve(String key) async => FlutterKeychain.get(key: key);

  Future<void> remove(String key) async => FlutterKeychain.remove(key: key);

  Future<void> removeAll(String key) async => FlutterKeychain.clear();
}
