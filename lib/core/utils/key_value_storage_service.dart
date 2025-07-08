
import 'package:pecs_new_arch/features/start/data/models/login_response_model.dart';

import 'key_value_storage_base.dart';

/// A service class for providing methods to store and retrieve key-value data
/// from common or secure storage.
class KeyValueStorageService {
  static const _accessTokenKey = 'accessToken';
  static const _userDataKey = 'userData';
   static const _userRoleKey = 'userRole';
  static const _localeKey = 'userLocale';

  final _keyValueStorage = KeyValueStorageBase();
  Future<String?> getLocale() async {
    return await _keyValueStorage.getEncrypted(_localeKey);
  }

  void setLocale(String locale) {
    _keyValueStorage.setEncrypted(_localeKey, locale);
  }
  Future<String?> getAccessToken() async {
    return await _keyValueStorage.getEncrypted(_accessTokenKey);
  }

  void setAccessToken(String token) {
    _keyValueStorage.setEncrypted(_accessTokenKey, token);
  }

    Future<String?> getUserRole() async {
    return await _keyValueStorage.getEncrypted(_userRoleKey);
  }

  void setUserRole(String token) {
    _keyValueStorage.setEncrypted(_userRoleKey, token);
  }


  Future<LoginResponseModel?> getUserData() async {
    String? data = await _keyValueStorage.getEncrypted(_userDataKey);
    if (data == null) return null;
    return loginResponseModelFromJson(data);
  }

  void setUserData(String value) {
    _keyValueStorage.setEncrypted(_userDataKey, value);
  }

  Future<String?> getImage(String key) async {
    return await _keyValueStorage.getEncrypted(key);
  }

  void setImage(String base64, String key) {
    _keyValueStorage.setEncrypted(key, base64);
  }

  void resetKeys() {
    _keyValueStorage
      ..clearCommon()
      ..clearEncrypted();
  }
}
