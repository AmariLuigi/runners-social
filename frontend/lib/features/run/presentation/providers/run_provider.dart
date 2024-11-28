import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/run_session.dart';
import '../../data/repositories/run_repository.dart';
import '../../../../core/services/api_service.dart';
import 'package:get_it/get_it.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return GetIt.instance<ApiService>();
});

final runRepositoryProvider = Provider<RunRepository>((ref) {
  return RunRepository();
});

final runsProvider = FutureProvider<List<RunSession>>((ref) async {
  final repository = ref.watch(runRepositoryProvider);
  return repository.getActiveRuns();
});

final myRunsProvider = FutureProvider<List<RunSession>>((ref) async {
  final repository = ref.watch(runRepositoryProvider);
  return repository.getMyRuns();
});

final selectedRunProvider = StateProvider<RunSession?>((ref) => null);

class RunCreationNotifier extends StateNotifier<AsyncValue<void>> {
  final RunRepository _repository;
  final ApiService _apiService;

  RunCreationNotifier(this._repository)
      : _apiService = GetIt.instance<ApiService>(),
        super(const AsyncValue.data(null));

  Future<void> createRun(RunSession run) async {
    state = const AsyncValue.loading();
    try {
      final response = await _apiService.post(
        '/api/runs',
        data: run.toJson(),
      );
      // After successful creation, refresh the runs list
      await _repository.getActiveRuns();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> joinRun(String runId) async {
    state = const AsyncValue.loading();
    try {
      final response = await _apiService.post(
        '/api/runs/$runId/join',
      );
      // After successful join, refresh the runs list
      await _repository.getActiveRuns();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> leaveRun(String runId) async {
    state = const AsyncValue.loading();
    try {
      final response = await _apiService.post(
        '/api/runs/$runId/leave',
      );
      // After successful leave, refresh the runs list
      await _repository.getActiveRuns();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final runCreationProvider = StateNotifierProvider<RunCreationNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(runRepositoryProvider);
  return RunCreationNotifier(repository);
});
