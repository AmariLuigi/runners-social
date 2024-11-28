import 'package:json_annotation/json_annotation.dart';

part 'location_model.g.dart';

@JsonSerializable()
class LocationModel {
  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'coordinates')
  final List<double> coordinates;

  @JsonKey(name: 'altitude')
  final double altitude;

  @JsonKey(name: 'speed')
  final double speed;

  @JsonKey(name: 'timestamp')
  final DateTime timestamp;

  LocationModel({
    this.type = 'Point',
    required this.coordinates,
    this.altitude = 0,
    this.speed = 0,
    required this.timestamp,
  });

  // Get longitude from coordinates
  double get longitude => coordinates[0];

  // Get latitude from coordinates
  double get latitude => coordinates[1];

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);

  factory LocationModel.fromPosition(double longitude, double latitude,
      {double altitude = 0, double speed = 0}) {
    return LocationModel(
      coordinates: [longitude, latitude],
      altitude: altitude,
      speed: speed,
      timestamp: DateTime.now(),
    );
  }

  LocationModel copyWith({
    String? type,
    List<double>? coordinates,
    double? altitude,
    double? speed,
    DateTime? timestamp,
  }) {
    return LocationModel(
      type: type ?? this.type,
      coordinates: coordinates ?? this.coordinates,
      altitude: altitude ?? this.altitude,
      speed: speed ?? this.speed,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
