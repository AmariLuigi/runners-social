import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../domain/entities/run.dart';
import '../../../core/services/api_service.dart';

final runProvider = StateNotifierProvider<RunNotifier, AsyncValue<List<Run>>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return RunNotifier(apiService);
});

class RunNotifier extends StateNotifier<AsyncValue<List<Run>>> {
  final ApiService _apiService;

  RunNotifier(this._apiService) : super(const AsyncValue.loading()) {
    loadRuns();
  }

  Future<void> loadRuns() async {
    try {
      final response = await _apiService.get('/api/runs');
      final List<dynamic> runsJson = response.data is Map<String, dynamic>
          ? response.data['runs'] as List<dynamic>
          : response.data as List<dynamic>;
      
      state = AsyncValue.data(runsJson.map((json) {
        // Convert 'title' to 'name' when parsing backend response
        if (json['title'] != null) {
          json['name'] = json['title'];
        }
        return Run.fromJson(json);
      }).toList());
    } catch (e, stack) {
      print('Error loading runs: $e');
      state = AsyncValue.error(e, stack);
      throw e;
    }
  }

  Future<void> createRun(Run run, Map<String, dynamic> payload) async {
    try {
      final response = await _apiService.post('/api/runs', data: {
        'title': run.name,  // Changed from 'name' to 'title' to match backend schema
        'description': run.description,
        'startTime': run.startTime.toIso8601String(),
        'type': run.type,
        'privacy': run.privacy,
        'style': run.style,
        'participants': run.participants.map((p) => {
          'user': p.id,
          'role': p.role,
          'isActive': p.isActive,
        }).toList(),
        if (run.plannedDistance != null) 'plannedDistance': run.plannedDistance,
        if (run.routePoints != null) 'routePoints': run.routePoints!.map((p) => p.toJson()).toList(),
        if (run.meetingPoint != null) 'meetingPoint': run.meetingPoint,
      });
      await loadRuns();
    } catch (e, stack) {
      print('Error creating run: $e');
      state = AsyncValue.error(e, stack);
      throw e;
    }
  }

  Future<void> joinRun(String runId) async {
    try {
      final response = await _apiService.post('/api/runs/$runId/join');
      final updatedRun = Run.fromJson(response.data);
      state = AsyncValue.data([...state.value!.map((run) => 
        run.id == runId ? updatedRun : run
      )]);
    } catch (e, stack) {
      print('Error joining run: $e');
      state = AsyncValue.error(e, stack);
      throw e;
    }
  }

  Future<void> leaveRun(String runId) async {
    try {
      await _apiService.post('/api/runs/$runId/leave');
      await loadRuns();
    } catch (e, stack) {
      print('Error leaving run: $e');
      state = AsyncValue.error(e, stack);
      throw e;
    }
  }

  Future<void> deleteRun(String runId) async {
    try {
      await _apiService.delete('/api/runs/$runId');
      await loadRuns();
    } catch (e, stack) {
      print('Error deleting run: $e');
      state = AsyncValue.error(e, stack);
      throw e;
    }
  }

  Future<void> updateRun(Run run) async {
    try {
      final response = await _apiService.put(
        '/api/runs/${run.id}',
        data: {
          'name': run.name,
          'type': run.type.toString().split('.').last,
          'startTime': run.startTime.toIso8601String(),
          'description': run.description,
          'privacy': run.privacy,
        },
      );
      final updatedRun = Run.fromJson(response.data);
      state = AsyncValue.data(state.value!.map((r) => r.id == run.id ? updatedRun : r).toList());
    } catch (e, stack) {
      print('Error updating run: $e');
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}
