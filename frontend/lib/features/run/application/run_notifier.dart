import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/run.dart';
import '../../../core/services/api_service.dart';

final runProvider = StateNotifierProvider<RunNotifier, List<Run>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return RunNotifier(apiService);
});

class RunNotifier extends StateNotifier<List<Run>> {
  final ApiService _apiService;
  static const String _baseUrl = '/api/runs';

  RunNotifier(this._apiService) : super([]) {
    loadRuns();
  }

  Future<void> loadRuns() async {
    try {
      final response = await _apiService.get(_baseUrl);
      if (response.data['runs'] != null) {
        final List<dynamic> runsJson = response.data['runs'];
        state = runsJson.map((json) => Run.fromJson(json)).toList();
      } else {
        state = [];
      }
    } catch (e) {
      print('Error loading runs: $e');
      rethrow;
    }
  }

  Future<void> createRun(Run run) async {
    try {
      final response = await _apiService.post(
        _baseUrl,
        data: {
          'name': run.name,
          'type': run.type.toString().split('.').last,
          'startTime': run.startTime.toIso8601String(),
          'description': run.description,
          'runStyle': run.runStyle,
          'maxParticipants': run.maxParticipants,
          'privacy': run.privacy,
        },
      );
      final newRun = Run.fromJson(response.data);
      state = [...state, newRun];
    } catch (e) {
      print('Error creating run: $e');
      rethrow;
    }
  }

  Future<void> updateRun(Run updatedRun) async {
    try {
      final response = await _apiService.put(
        '$_baseUrl/${updatedRun.id}',
        data: {
          'name': updatedRun.name,
          'type': updatedRun.type.toString().split('.').last,
          'startTime': updatedRun.startTime.toIso8601String(),
          'description': updatedRun.description,
          'runStyle': updatedRun.runStyle,
          'maxParticipants': updatedRun.maxParticipants,
          'privacy': updatedRun.privacy,
        },
      );
      final run = Run.fromJson(response.data);
      state = state.map((r) {
        if (r.id == updatedRun.id) {
          return run;
        }
        return r;
      }).toList();
    } catch (e) {
      print('Error updating run: $e');
      rethrow;
    }
  }

  Future<void> deleteRun(String runId) async {
    try {
      await _apiService.delete('$_baseUrl/$runId');
      state = state.where((run) => run.id != runId).toList();
    } catch (e) {
      print('Error deleting run: $e');
      rethrow;
    }
  }

  Future<void> joinRun(String runId) async {
    try {
      final response = await _apiService.post('$_baseUrl/$runId/join');
      final updatedRun = Run.fromJson(response.data);
      state = state.map((run) {
        if (run.id == runId) {
          return updatedRun;
        }
        return run;
      }).toList();
    } catch (e) {
      print('Error joining run: $e');
      rethrow;
    }
  }

  Future<void> leaveRun(String runId) async {
    try {
      final response = await _apiService.post('$_baseUrl/$runId/leave');
      final updatedRun = Run.fromJson(response.data);
      state = state.map((run) {
        if (run.id == runId) {
          return updatedRun;
        }
        return run;
      }).toList();
    } catch (e) {
      print('Error leaving run: $e');
      rethrow;
    }
  }

  List<Run> getParticipatingRuns() {
    return state.where((run) => run.isParticipant).toList();
  }

  List<Run> getPublicRuns() {
    return state.where((run) => run.privacy == 'public').toList();
  }
}
