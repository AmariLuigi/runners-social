import 'package:dio/dio.dart';
import '../../domain/entities/run.dart';
import '../../domain/entities/chat_message.dart';
import '../../../core/config/api_config.dart';

class RunApiService {
  final Dio _dio;
  final String _baseUrl;

  RunApiService()
      : _dio = Dio(),
        _baseUrl = ApiConfig.baseUrl {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token from secure storage
          final token = await ApiConfig.getAuthToken();
          options.headers['Authorization'] = 'Bearer $token';
          return handler.next(options);
        },
      ),
    );
  }

  Future<List<Run>> getMyRuns() async {
    try {
      final response = await _dio.get('$_baseUrl/runs/my');
      return (response.data as List)
          .map((json) => Run.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Run>> getPublicRuns() async {
    try {
      final response = await _dio.get('$_baseUrl/runs/public');
      return (response.data as List)
          .map((json) => Run.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Run> getRun(String runId) async {
    try {
      final response = await _dio.get('$_baseUrl/runs/$runId');
      return Run.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Run> createRun(Map<String, dynamic> runData) async {
    try {
      final response = await _dio.post('$_baseUrl/runs', data: runData);
      return Run.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Run> joinRun(String runId) async {
    try {
      final response = await _dio.post('$_baseUrl/runs/$runId/join');
      return Run.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<ChatMessage>> getChatMessages(String runId) async {
    try {
      final response = await _dio.get('$_baseUrl/runs/$runId/chat');
      return (response.data as List)
          .map((json) => ChatMessage.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<ChatMessage> sendChatMessage(String runId, String content) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/runs/$runId/chat',
        data: {'content': content},
      );
      return ChatMessage.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      final response = error.response;
      if (response != null) {
        final message = response.data['message'] ?? 'An error occurred';
        return Exception(message);
      }
      return Exception(error.message ?? 'Network error occurred');
    }
    return Exception('An unexpected error occurred');
  }
}
