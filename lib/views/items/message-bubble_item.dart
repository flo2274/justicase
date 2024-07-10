import 'package:flutter/material.dart';

import '../../utils/configs/text_theme_config.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String sender;
  final DateTime timestamp;
  final bool isMe;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.sender,
    required this.timestamp,
    required this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: isMe ? Colors.lightBlueAccent : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: isMe ? Radius.circular(12) : Radius.zero,
            bottomRight: isMe ? Radius.zero : Radius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sender,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isMe ? Colors.white : TextThemeConfig.textSecondary,
              ),
            ),
            SizedBox(height: 4),
            Text(
              message,
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 4),
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
