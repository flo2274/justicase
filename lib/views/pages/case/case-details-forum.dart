import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/models/chat_message.dart';
import 'package:mobile_anw/services/api_service.dart';
import '../../../utils/configs/text_theme_config.dart';
import '../../../utils/user_preferences.dart';

class CaseDetailsForum extends StatefulWidget {
  final Case myCase;

  const CaseDetailsForum({Key? key, required this.myCase}) : super(key: key);

  @override
  _CaseDetailsForumState createState() => _CaseDetailsForumState();
}

class _CaseDetailsForumState extends State<CaseDetailsForum> {
  List<ChatMessage> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  late int _userId;
  late String _username;
  late bool _isAdmin;
  late Timer _timer;
  bool _isUserDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _startMessageLoading();
  }

  void _startMessageLoading() {
    _timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      if (_isUserDataLoaded) {
        _loadMessages();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    await UserPreferences.fetchUserData((userId, username, isAdmin) {
      setState(() {
        _userId = userId;
        _username = username;
        _isAdmin = isAdmin;
        _isUserDataLoaded = true;
      });
      _loadMessages(); // Load messages once user data is loaded
    });
  }

  Future<void> _loadMessages() async {
    final int caseId = widget.myCase.id ?? 0;
    try {
      final messages = await APIService.getMessagesFromCase(caseId);
      setState(() {
        _messages = messages;
      });
    } catch (e) {
      print('Failed to load messages: $e');
      // Handle the error appropriately
    }
  }

  void _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    final int caseId = widget.myCase.id ?? 0;

    try {
      final message = ChatMessage(
        text: _messageController.text,
        username: _username,
        timestamp: DateTime.now(),
      );

      final success = await APIService.sendMessageToCase(caseId, message);
      if (success) {
        setState(() {
          _messages.add(message); // Add new message to the end of the list
        });
        _messageController.clear();
      } else {
        print('Failed to send message');
      }
    } catch (e) {
      print('Failed to send message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? Center(child: Text('Im Forum gibt es bisher keine Nachrichten...'))
                : ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (ctx, index) {
                final message = _messages[index];
                return MessageBubble(
                  key: ValueKey(message.id),
                  message: message.text,
                  sender: message.username,
                  timestamp: message.timestamp,
                  isMe: message.username == _username,
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
                SizedBox(width: 8),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sender,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isMe ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 4),
            Text(
              message,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 4),
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
