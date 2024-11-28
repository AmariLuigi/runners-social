class ChatMessage {
  final String id;
  final String content;
  final String senderId;
  final String senderName;
  final DateTime timestamp;
  final bool isCurrentUser;

  ChatMessage({
    required this.id,
    required this.content,
    required this.senderId,
    required this.senderName,
    required this.timestamp,
    required this.isCurrentUser,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json, String currentUserId) {
    return ChatMessage(
      id: json['id'] as String,
      content: json['content'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isCurrentUser: json['senderId'] == currentUserId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'senderId': senderId,
      'senderName': senderName,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
