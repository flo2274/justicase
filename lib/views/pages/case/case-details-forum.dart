import 'package:flutter/material.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/models/chat_message.dart';
import 'package:mobile_anw/services/api_service.dart';

class CaseDetailsForum extends StatefulWidget {
  final Case myCase;

  const CaseDetailsForum({Key? key, required this.myCase}) : super(key: key);

  @override
  _CaseDetailsForumState createState() => _CaseDetailsForumState();
}

class _CaseDetailsForumState extends State<CaseDetailsForum> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final int caseId = widget.myCase.id!; // Ensure widget.myCase.id is not null
    final messages = await APIService.getMessages(caseId);
    setState(() {
      _messages.addAll(messages);
    });
  }

  void _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    final int caseId = widget.myCase.id!; // Ensure widget.myCase.id is not null

    final message = ChatMessage(
      text: _messageController.text,
      sender: 'Me', // Replace with actual sender information
      timestamp: DateTime.now(),
    );

    final success = await APIService.sendMessage(caseId, message);
    if (success) {
      setState(() {
        _messages.insert(0, message);
      });
      _messageController.clear();
    } else {
      // Handle message send failure
      print('Failed to send message');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat for case: ${widget.myCase.name}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (ctx, index) {
                final message = _messages[index];
                return MessageBubble(
                  message: message.text,
                  sender: message.sender,
                  timestamp: message.timestamp,
                  isMe: message.sender == 'Me', // Replace with actual user check
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(labelText: 'Send a message...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
          color: isMe ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: isMe ? Radius.circular(12) : Radius.zero,
            bottomRight: isMe ? Radius.zero : Radius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              sender,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isMe ? Colors.white : Colors.black,
              ),
            ),
            Text(
              message,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
              ),
              textAlign: isMe ? TextAlign.end : TextAlign.start,
            ),
            Text(
              '${timestamp.hour}:${timestamp.minute}',
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
