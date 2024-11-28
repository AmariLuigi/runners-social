import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/auth_repository.dart';
import 'dart:developer' as developer;

class AuthRepositoryImpl implements AuthRepository {
  final http.Client _client;
  final FlutterSecureStorage _storage;
  final String _baseUrl;

  AuthRepositoryImpl({
    required http.Client client,
    required FlutterSecureStorage storage,
    required String baseUrl,
  })  : _client = client,
        _storage = storage,
        _baseUrl = baseUrl;

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      developer.log('Attempting login with email: $email', name: 'Auth');
      
      final response = await _client.post(
        Uri.parse('$_baseUrl/api/auth/login'),
        body: json.encode({
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      final responseData = json.decode(response.body);
      developer.log('Login response: ${response.statusCode} - $responseData', name: 'Auth');

      if (response.statusCode == 200) {
        final token = responseData['token'];
        if (token == null) {
          return const Left(AuthenticationFailure('No token received'));
        }

        await _storage.write(key: 'token', value: token);
        await _storage.write(key: 'userId', value: responseData['user']['id']);

        final user = User.fromJson({
          'id': responseData['user']['id'],
          'email': responseData['user']['email'],
          'username': responseData['user']['username'],
          'profile': responseData['user']['profile'] ?? {},
        });

        developer.log('User created: $user', name: 'Auth');
        return Right(user);
      } else {
        return Left(AuthenticationFailure(
          responseData['error'] ?? responseData['message'] ?? 'Login failed',
        ));
      }
    } catch (e, stackTrace) {
      developer.log(
        'Login error: $e\nStack trace: $stackTrace',
        name: 'Auth',
        error: e,
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      developer.log('Attempting registration for username: $username', name: 'Auth');
      
      final response = await _client.post(
        Uri.parse('$_baseUrl/api/auth/register'),
        body: json.encode({
          'email': email,
          'password': password,
          'username': username,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      final responseData = json.decode(response.body);
      developer.log('Registration response: ${response.statusCode} - $responseData', name: 'Auth');

      if (response.statusCode == 201) {
        final token = responseData['token'];
        if (token == null) {
          return const Left(AuthenticationFailure('No token received'));
        }

        await _storage.write(key: 'token', value: token);

        final user = User.fromJson({
          'id': responseData['user']['id'],
          'email': responseData['user']['email'],
          'username': responseData['user']['username'],
          'profile': responseData['user']['profile'] ?? {},
        });

        developer.log('User created: $user', name: 'Auth');
        return Right(user);
      } else {
        final errorMessage = responseData['error'] ?? 
                           responseData['details'] ?? 
                           responseData['message'] ?? 
                           'Registration failed';
        return Left(AuthenticationFailure(errorMessage));
      }
    } catch (e, stackTrace) {
      developer.log(
        'Registration error: $e\nStack trace: $stackTrace',
        name: 'Auth',
        error: e,
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _storage.delete(key: 'token');
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) {
        developer.log('No token found in storage', name: 'Auth');
        return Left(AuthenticationFailure('No token found'));
      }

      final response = await _client.get(
        Uri.parse('$_baseUrl/api/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      developer.log('Get current user response: ${response.statusCode}', name: 'Auth');

      if (response.statusCode == 200) {
        final user = User.fromJson(json.decode(response.body));
        developer.log('Current user retrieved: $user', name: 'Auth');
        return Right(user);
      } else if (response.statusCode == 401) {
        developer.log('Token is invalid or expired', name: 'Auth');
        await _storage.delete(key: 'token');
        return Left(AuthenticationFailure('Token is invalid or expired'));
      } else {
        final errorMessage = _parseErrorMessage(response);
        developer.log('Failed to get current user: $errorMessage', name: 'Auth');
        return Left(AuthenticationFailure(errorMessage));
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error getting current user: $e\nStack trace: $stackTrace',
        name: 'Auth',
        error: e,
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  String _parseErrorMessage(http.Response response) {
    try {
      final body = json.decode(response.body);
      return body['error'] ?? body['message'] ?? 'Unknown error occurred';
    } catch (_) {
      return 'Failed to parse error message';
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile({
    String? username,
    String? bio,
    String? profileImageUrl,
  }) async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) {
        return Left(AuthenticationFailure('No token found'));
      }

      final response = await _client.put(
        Uri.parse('$_baseUrl/api/auth/profile'),
        body: json.encode({
          if (username != null) 'username': username,
          if (bio != null) 'bio': bio,
          if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(AuthenticationFailure(
          json.decode(response.body)['message'] ?? 'Update failed',
        ));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) {
        return Left(AuthenticationFailure('No token found'));
      }

      final response = await _client.put(
        Uri.parse('$_baseUrl/api/auth/password'),
        body: json.encode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(AuthenticationFailure(
          json.decode(response.body)['message'] ?? 'Password update failed',
        ));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String email,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/api/auth/reset-password'),
        body: json.encode({
          'email': email,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(AuthenticationFailure(
          json.decode(response.body)['message'] ?? 'Reset password failed',
        ));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail({
    required String token,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/api/auth/verify-email'),
        body: json.encode({
          'token': token,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(AuthenticationFailure(
          json.decode(response.body)['message'] ?? 'Email verification failed',
        ));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> refreshToken() async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) {
        return Left(AuthenticationFailure('No token found'));
      }

      final response = await _client.post(
        Uri.parse('$_baseUrl/api/auth/refresh'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _storage.write(key: 'token', value: data['token']);
        return const Right(null);
      } else {
        return Left(AuthenticationFailure(
          json.decode(response.body)['message'] ?? 'Token refresh failed',
        ));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: 'token');
    return token != null;
  }
}
