import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../domain/entities/run.dart';

final runProvider = StateNotifierProvider<RunNotifier, List<Run>>((ref) {
  return RunNotifier();
});

class RunNotifier extends StateNotifier<List<Run>> {
  RunNotifier() : super([
    // Add some mock runs
    Run(
      id: const Uuid().v4(),
      name: 'Morning Jog',
      type: RunType.solo,
      status: RunStatus.upcoming,
      startTime: DateTime.now().add(const Duration(days: 1)),
      locationName: 'Central Park',
      distanceGoal: 5.0,
      isPublic: true,
      isParticipant: true,
      participants: ['current_user'],
    ),
    Run(
      id: const Uuid().v4(),
      name: 'Group Run',
      type: RunType.group,
      status: RunStatus.upcoming,
      startTime: DateTime.now().add(const Duration(days: 2)),
      locationName: 'City Trail',
      distanceGoal: 10.0,
      isPublic: true,
      hasChatEnabled: true,
      participants: ['other_user'],
    ),
  ]);

  Future<void> addRun(Run run) async {
    state = [...state, run];
  }

  Future<void> updateRunStatus(String runId, RunStatus newStatus) async {
    state = [
      for (final run in state)
        if (run.id == runId)
          run.copyWith(status: newStatus)
        else
          run,
    ];
  }

  Future<void> deleteRun(String runId) async {
    state = state.where((run) => run.id != runId).toList();
  }

  Future<void> joinRun(String runId) async {
    state = [
      for (final run in state)
        if (run.id == runId)
          run.copyWith(
            isParticipant: true,
            participants: [...?run.participants, 'current_user'],
          )
        else
          run,
    ];
  }

  Future<void> leaveRun(String runId) async {
    state = [
      for (final run in state)
        if (run.id == runId)
          run.copyWith(
            isParticipant: false,
            participants: run.participants?.where((id) => id != 'current_user').toList(),
          )
        else
          run,
    ];
  }

  List<Run> getParticipatingRuns() {
    return state.where((run) => run.isParticipant).toList();
  }

  List<Run> getPublicRuns() {
    return state.where((run) => run.isPublic ?? false).toList();
  }
}
