import 'package:flutter/material.dart';

import '../../utils/configs/text_theme_config.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String sender;
  final DateTime timestamp;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.sender,
    required this.timestamp,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: isMe ? Colors.lightBlueAccent : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Text(
                sender,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: TextThemeConfig.textSecondary,
                ),
              ),
            if (!isMe) const SizedBox(height: 4),
            Text(
              message,
              style: const TextStyle(
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${timestamp.toLocal().hour.toString().padLeft(2, '0')}:${timestamp.toLocal().minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 10,
                color: isMe ? Colors.white60 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
