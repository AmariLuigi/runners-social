import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../domain/entities/run.dart';
import 'package:latlong2/latlong.dart';

final runProvider = StateNotifierProvider<RunNotifier, List<Run>>((ref) {
  return RunNotifier();
});

class RunNotifier extends StateNotifier<List<Run>> {
  RunNotifier() : super([]);

  void addRun({
    required String name,
    required RunType type,
    required DateTime startTime,
    required LatLng location,
    String? locationName,
    double? distanceGoal,
    bool? isPublic,
    List<String>? participants,
    bool? hasChatEnabled,
  }) {
    final run = Run(
      id: const Uuid().v4(),
      name: name,
      type: type,
      status: RunStatus.upcoming,
      startTime: startTime,
      location: location,
      locationName: locationName,
      distanceGoal: distanceGoal,
      isPublic: isPublic,
      participants: participants,
      hasChatEnabled: hasChatEnabled,
    );

    state = [...state, run];
  }

  void updateRunStatus(String runId, RunStatus newStatus) {
    state = [
      for (final run in state)
        if (run.id == runId)
          run.copyWith(status: newStatus)
        else
          run,
    ];
  }

  void deleteRun(String runId) {
    state = state.where((run) => run.id != runId).toList();
  }

  List<Run> getUpcomingRuns() {
    return state
        .where((run) => run.status == RunStatus.upcoming)
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  List<Run> getOngoingRuns() {
    return state.where((run) => run.status == RunStatus.ongoing).toList();
  }

  List<Run> getCompletedRuns() {
    return state
        .where((run) => run.status == RunStatus.completed)
        .toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));
  }
}
