class ChatMessage {
  final int? id;
  final String text;
  final String username;
  final DateTime timestamp;

  ChatMessage({
    this.id,
    required this.text,
    required this.username,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as int?,
      text: json['text'] ?? '',
      username: json['username'] ?? '',
      timestamp: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'sender': username,
      'createdAt': timestamp.toIso8601String(),
    };
  }
}
