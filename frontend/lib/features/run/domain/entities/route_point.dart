class RoutePoint {
  final double latitude;
  final double longitude;
  final int order;

  RoutePoint({
    required this.latitude,
    required this.longitude,
    required this.order,
  });

  factory RoutePoint.fromJson(Map<String, dynamic> json) {
    return RoutePoint(
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      order: json['order']?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'order': order,
    };
  }
}
