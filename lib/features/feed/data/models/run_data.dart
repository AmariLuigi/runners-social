import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class RunData extends Equatable {
  final String id;
  final double distance; // in kilometers
  final Duration duration;
  final double averagePace; // minutes per kilometer
  final List<LatLng> route;
  final DateTime startTime;
  final DateTime endTime;
  final double caloriesBurned;
  final double elevationGain; // in meters

  const RunData({
    required this.id,
    required this.distance,
    required this.duration,
    required this.averagePace,
    required this.route,
    required this.startTime,
    required this.endTime,
    required this.caloriesBurned,
    required this.elevationGain,
  });

  RunData copyWith({
    String? id,
    double? distance,
    Duration? duration,
    double? averagePace,
    List<LatLng>? route,
    DateTime? startTime,
    DateTime? endTime,
    double? caloriesBurned,
    double? elevationGain,
  }) {
    return RunData(
      id: id ?? this.id,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      averagePace: averagePace ?? this.averagePace,
      route: route ?? this.route,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      elevationGain: elevationGain ?? this.elevationGain,
    );
  }

  factory RunData.fromJson(Map<String, dynamic> json) {
    return RunData(
      id: json['id'] as String,
      distance: (json['distance'] as num).toDouble(),
      duration: Duration(seconds: json['duration'] as int),
      averagePace: (json['averagePace'] as num).toDouble(),
      route: (json['route'] as List<dynamic>).map((e) {
        final coords = e as Map<String, dynamic>;
        return LatLng(
          (coords['lat'] as num).toDouble(),
          (coords['lng'] as num).toDouble(),
        );
      }).toList(),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      caloriesBurned: (json['caloriesBurned'] as num).toDouble(),
      elevationGain: (json['elevationGain'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'distance': distance,
      'duration': duration.inSeconds,
      'averagePace': averagePace,
      'route': route.map((coord) => {
        'lat': coord.latitude,
        'lng': coord.longitude,
      }).toList(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'caloriesBurned': caloriesBurned,
      'elevationGain': elevationGain,
    };
  }

  @override
  List<Object> get props => [
    id,
    distance,
    duration,
    averagePace,
    route,
    startTime,
    endTime,
    caloriesBurned,
    elevationGain,
  ];

  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  String get formattedPace {
    final minutes = averagePace.floor();
    final seconds = ((averagePace - minutes) * 60).round();
    return '$minutes:${seconds.toString().padLeft(2, '0')}/km';
  }

  String get formattedDistance {
    return '${distance.toStringAsFixed(2)} km';
  }
}
