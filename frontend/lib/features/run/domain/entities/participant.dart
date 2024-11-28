class Participant {
  final String userId;
  final String name;
  final String? avatarUrl;
  final DateTime joinedAt;
  final bool isAdmin;

  Participant({
    required this.userId,
    required this.name,
    this.avatarUrl,
    required this.joinedAt,
    this.isAdmin = false,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      avatarUrl: json['avatarUrl'],
      joinedAt: json['joinedAt'] != null
          ? DateTime.parse(json['joinedAt'].toString())
          : DateTime.now(),
      isAdmin: json['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'avatarUrl': avatarUrl,
      'joinedAt': joinedAt.toIso8601String(),
      'isAdmin': isAdmin,
    };
  }
}
