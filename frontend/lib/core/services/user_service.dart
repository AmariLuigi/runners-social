import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _currentUserId;
  String? _currentUsername;

  factory UserService() {
    return _instance;
  }

  UserService._internal();

  Future<void> initialize() async {
    _currentUserId = await _storage.read(key: 'user_id');
    _currentUsername = await _storage.read(key: 'username');
  }

  Future<void> setCurrentUser({required String userId, required String username}) async {
    _currentUserId = userId;
    _currentUsername = username;
    await _storage.write(key: 'user_id', value: userId);
    await _storage.write(key: 'username', value: username);
  }

  String? get currentUserId => _currentUserId;
  String? get username => _currentUsername;

  Future<void> clearCurrentUser() async {
    _currentUserId = null;
    _currentUsername = null;
    await _storage.delete(key: 'user_id');
    await _storage.delete(key: 'username');
  }
}

final userService = GetIt.instance<UserService>();
