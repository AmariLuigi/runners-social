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
    required LatLng location,
    String? locationName,
    double? distanceGoal,
    bool? isPublic,
    List<String>? participants,
    bool? hasChatEnabled,
  }) = _Run;

  factory Run.fromJson(Map<String, dynamic> json) => _$RunFromJson(json);
}
