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
      id: json['id'] as int?, // Hier sicherstellen, dass 'id' ein int oder null ist
      text: json['text'] ?? '', // Default-Wert für 'text'
      username: json['username'] ?? '', // Default-Wert für 'sender'
      timestamp: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(), // Default-Wert für 'createdAt'
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
