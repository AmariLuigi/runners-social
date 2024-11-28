import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

class ApiService {
  static const String baseUrl = 'http://localhost:3000';
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ApiService() {
    _dio.options.baseUrl = baseUrl;
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onError: _onError,
      ),
    );
  }

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read(key: 'token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    if (error.response?.statusCode == 401) {
      try {
        // Try to refresh the token
        final refreshToken = await _storage.read(key: 'refreshToken');
        if (refreshToken != null) {
          final response = await _dio.post(
            '/auth/refresh',
            data: {'refreshToken': refreshToken},
            options: Options(headers: {'Authorization': null}),
          );
          
          // Save the new tokens
          await _storage.write(key: 'token', value: response.data['token']);
          await _storage.write(key: 'refreshToken', value: response.data['refreshToken']);
          
          // Retry the original request
          final originalRequest = error.requestOptions;
          final opts = Options(
            method: originalRequest.method,
            headers: {'Authorization': 'Bearer ${response.data['token']}'},
          );
          
          final retryResponse = await _dio.request(
            originalRequest.path,
            options: opts,
            data: originalRequest.data,
            queryParameters: originalRequest.queryParameters,
          );
          
          return handler.resolve(retryResponse);
        }
      } catch (e) {
        // If refresh fails, clear tokens and continue with error
        await _storage.delete(key: 'token');
        await _storage.delete(key: 'refreshToken');
      }
    }
    handler.next(error);
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    print('Making GET request to: $path');
    print('Query parameters: $queryParameters');
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      print('Response: ${response.data}');
      return response;
    } catch (e) {
      print('Error in GET request: $e');
      if (e is DioException) {
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }
      rethrow;
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    print('Making POST request to: $path');
    print('Request data: $data');
    try {
      final response = await _dio.post(path, data: data, queryParameters: queryParameters);
      print('Response: ${response.data}');
      return response;
    } catch (e) {
      print('Error in POST request: $e');
      if (e is DioException) {
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }
      rethrow;
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    print('Making PUT request to: $path');
    print('Request data: $data');
    try {
      final response = await _dio.put(path, data: data, queryParameters: queryParameters);
      print('Response: ${response.data}');
      return response;
    } catch (e) {
      print('Error in PUT request: $e');
      if (e is DioException) {
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }
      rethrow;
    }
  }

  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    print('Making DELETE request to: $path');
    print('Query parameters: $queryParameters');
    try {
      final response = await _dio.delete(path, queryParameters: queryParameters);
      print('Response: ${response.data}');
      return response;
    } catch (e) {
      print('Error in DELETE request: $e');
      if (e is DioException) {
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }
      rethrow;
    }
  }
}
