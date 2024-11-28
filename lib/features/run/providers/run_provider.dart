import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/run.dart';

final runProvider = StateNotifierProvider<RunNotifier, List<Run>>((ref) {
  return RunNotifier();
});

class RunNotifier extends StateNotifier<List<Run>> {
  RunNotifier() : super([]);

  void addRun(Run run) {
    state = [...state, run];
  }

  void deleteRun(String id) {
    state = state.where((run) => run.id != id).toList();
  }

  void joinRun(String id) {
    state = state.map((run) {
      if (run.id == id) {
        return run.copyWith(isParticipant: true);
      }
      return run;
    }).toList();
  }

  void updateRun(Run updatedRun) {
    state = state.map((run) {
      if (run.id == updatedRun.id) {
        return updatedRun;
      }
      return run;
    }).toList();
  }
}
