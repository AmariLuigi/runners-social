import 'package:flutter_secure_storage.dart';

class ApiConfig {
  static const String baseUrl = 'http://localhost:3000/api';
  static const String wsUrl = 'ws://localhost:3000/ws';

  static final _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  static Future<String?> getAuthToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> setAuthToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<void> clearAuthToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
