import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'run.freezed.dart';
part 'run.g.dart';

enum RunType {
  solo,
  group
}

enum RunStatus {
  upcoming,
  ongoing,
  completed
}

@freezed
class Run with _$Run {
  const factory Run({
    required String id,
    required String name,
    required RunType type,
    required RunStatus status,
    required DateTime startTime,
    String? locationName,
    double? distanceGoal,
    bool? isPublic,
    List<String>? participants,
    bool? hasChatEnabled,
    @Default(false) bool isParticipant,
  }) = _Run;

  factory Run.fromJson(Map<String, dynamic> json) => _$RunFromJson(json);
}

extension RunX on Run {
  Run copyWith({
    String? id,
    String? name,
    RunType? type,
    RunStatus? status,
    DateTime? startTime,
    String? locationName,
    double? distanceGoal,
    bool? isPublic,
    List<String>? participants,
    bool? hasChatEnabled,
    bool? isParticipant,
  }) {
    return Run(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      locationName: locationName ?? this.locationName,
      distanceGoal: distanceGoal ?? this.distanceGoal,
      isPublic: isPublic ?? this.isPublic,
      participants: participants ?? this.participants,
      hasChatEnabled: hasChatEnabled ?? this.hasChatEnabled,
      isParticipant: isParticipant ?? this.isParticipant,
    );
  }
}
