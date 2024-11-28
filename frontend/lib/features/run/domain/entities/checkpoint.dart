class Checkpoint {
  final String id;
  final double latitude;
  final double longitude;
  final String name;
  final int order;
  final bool isCompleted;

  Checkpoint({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.order,
    this.isCompleted = false,
  });

  factory Checkpoint.fromJson(Map<String, dynamic> json) {
    return Checkpoint(
      id: json['id'] ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      name: json['name'] ?? '',
      order: json['order']?.toInt() ?? 0,
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
      'order': order,
      'isCompleted': isCompleted,
    };
  }
}
