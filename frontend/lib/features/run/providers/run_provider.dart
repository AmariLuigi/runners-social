import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../domain/entities/run.dart';
import '../../../core/services/api_service.dart';

final runProvider = StateNotifierProvider<RunNotifier, List<Run>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return RunNotifier(apiService);
});

class RunNotifier extends StateNotifier<List<Run>> {
  final ApiService _apiService;

  RunNotifier(this._apiService) : super([]) {
    loadRuns();
  }

  Future<void> loadRuns() async {
    try {
      final response = await _apiService.get('/api/runs');
      // Handle both wrapped and unwrapped response formats
      final List<dynamic> runsJson = response.data is Map<String, dynamic> 
          ? response.data['runs'] as List<dynamic>
          : response.data as List<dynamic>;
      
      state = runsJson.map((json) {
        // Add currentUserId to each run for isParticipant check
        final userId = json['user']?['_id']?.toString() ?? '';
        json['currentUserId'] = userId;
        return Run.fromJson(json);
      }).toList();
    } catch (e) {
      print('Error loading runs: $e');
      rethrow;
    }
  }

  Future<void> createRun(Run run) async {
    try {
      final response = await _apiService.post(
        '/api/runs',
        data: {
          'title': run.name,
          'type': run.type.toString().split('.').last,
          'startTime': run.startTime.toIso8601String(),
          'description': run.description,
          'runStyle': 'free', // Always set a default runStyle
          'maxParticipants': run.maxParticipants,
          'privacy': run.privacy ?? 'public',
          'status': 'planned',
        },
      );
      
      // Extract the runSession from the response and add currentUserId
      final runSessionData = response.data['runSession'] as Map<String, dynamic>;
      final userId = (runSessionData['user'] as Map<String, dynamic>)['_id'];
      runSessionData['currentUserId'] = userId;
      
      final newRun = Run.fromJson(runSessionData);
      state = [...state, newRun];
    } catch (e) {
      print('Error creating run: $e');
      rethrow;
    }
  }

  Future<void> joinRun(String id) async {
    try {
      final response = await _apiService.post('/api/runs/$id/join');
      final updatedRun = Run.fromJson(response.data);
      state = state.map((run) => run.id == id ? updatedRun : run).toList();
    } catch (e) {
      print('Error joining run: $e');
      rethrow;
    }
  }

  Future<void> leaveRun(String id) async {
    try {
      final response = await _apiService.post('/api/runs/$id/leave');
      
      // Check if the response contains a message or a full run object
      if (response.data is Map<String, dynamic> && response.data['message'] != null) {
        // If it's just a message response, remove the run from the list
        state = state.where((run) => run.id != id).toList();
        return;
      }

      // Otherwise, handle the full run object response
      final runData = response.data;
      runData['currentUserId'] = runData['user']?['_id'];
      final updatedRun = Run.fromJson(runData);
      
      if (updatedRun.status == 'cancelled') {
        // If the run is cancelled, remove it from the list
        state = state.where((run) => run.id != id).toList();
      } else {
        // Otherwise, update it in the list
        state = state.map((run) => run.id == id ? updatedRun : run).toList();
      }
    } catch (e) {
      print('Error leaving run: $e');
      // Load runs to ensure the UI is in sync with the backend
      await loadRuns();
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
          'runStyle': run.runStyle,
          'maxParticipants': run.maxParticipants,
          'privacy': run.privacy,
        },
      );
      final updatedRun = Run.fromJson(response.data);
      state = state.map((r) => r.id == run.id ? updatedRun : r).toList();
    } catch (e) {
      print('Error updating run: $e');
      rethrow;
    }
  }

  Future<void> deleteRun(String id) async {
    try {
      await _apiService.delete('/api/runs/$id');
      state = state.where((run) => run.id != id).toList();
    } catch (e) {
      print('Error deleting run: $e');
      rethrow;
    }
  }
}
