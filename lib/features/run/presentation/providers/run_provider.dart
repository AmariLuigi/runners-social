import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/run_session.dart';
import '../../data/repositories/run_repository.dart';

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

final runCreationProvider = StateNotifierProvider<RunCreationNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(runRepositoryProvider);
  return RunCreationNotifier(repository);
});

class RunCreationNotifier extends StateNotifier<AsyncValue<void>> {
  final RunRepository _repository;

  RunCreationNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> createRun(RunSession run) async {
    state = const AsyncValue.loading();
    try {
      await _repository.createRun(run);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> joinRun(String runId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.joinRun(runId);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> leaveRun(String runId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.leaveRun(runId);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
