import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

part 'location_model.freezed.dart';
part 'location_model.g.dart';

@freezed
class LocationModel with _$LocationModel {
  const factory LocationModel({
    required double latitude,
    required double longitude,
    required double altitude,
    required double speed,
    required double accuracy,
    required double bearing,
    required DateTime timestamp,
  }) = _LocationModel;

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  const LocationModel._();

  LatLng toLatLng() => LatLng(latitude, longitude);

  static LocationModel fromLatLng(LatLng latLng) => LocationModel(
        latitude: latLng.latitude,
        longitude: latLng.longitude,
        altitude: 0,
        speed: 0,
        accuracy: 0,
        bearing: 0,
        timestamp: DateTime.now(),
      );

  static LocationModel fromPosition(Position position) => LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        altitude: position.altitude,
        speed: position.speed,
        accuracy: position.accuracy,
        bearing: position.heading,
        timestamp: position.timestamp,
      );
}
