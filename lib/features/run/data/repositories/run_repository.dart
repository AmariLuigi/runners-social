import 'package:dio/dio.dart';
import '../models/run_session.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';

class RunRepository {
  final ApiService _apiService = ApiService();

  Future<List<RunSession>> getActiveRuns() async {
    try {
      final response = await _apiService.get('/runs/active');
      final List<dynamic> runsJson = response.data['runs'];
      return runsJson.map((json) => RunSession.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<RunSession>> getMyRuns() async {
    try {
      final response = await _apiService.get('/runs');
      final List<dynamic> runsJson = response.data['runs'];
      return runsJson.map((json) => RunSession.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<RunSession> createRun(RunSession run) async {
    try {
      final response = await _apiService.post(
        '/runs',
        data: run.toJson(),
      );
      return RunSession.fromJson(response.data['runSession']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<RunSession> getRun(String runId) async {
    try {
      final response = await _apiService.get('/runs/$runId');
      return RunSession.fromJson(response.data['runSession']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> joinRun(String runId) async {
    try {
      await _apiService.post('/runs/$runId/join');
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> leaveRun(String runId) async {
    try {
      await _apiService.post('/runs/$runId/leave');
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      final response = error.response;
      if (response != null) {
        return Exception(response.data['error'] ?? 'An error occurred');
      }
      return Exception(error.message ?? 'Network error occurred');
    }
    return Exception('An unexpected error occurred');
  }
}
