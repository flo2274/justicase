import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/models/chat_message.dart';
import 'package:mobile_anw/services/api_service.dart';
import '../../../utils/configs/text_theme_config.dart';
import '../../../utils/user_preferences.dart';
import '../../items/message-bubble_item.dart';

class CaseDetailsForum extends StatefulWidget {
  final Case myCase;

  const CaseDetailsForum({Key? key, required this.myCase}) : super(key: key);

  @override
  _CaseDetailsForumState createState() => _CaseDetailsForumState();
}

class _CaseDetailsForumState extends State<CaseDetailsForum> {
  List<ChatMessage> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
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
    _scrollController.dispose();
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
      _loadMessages();
    });
  }

  Future<void> _loadMessages() async {
    final int caseId = widget.myCase.id ?? 0;
    try {
      final messages = await APIService.getMessagesFromCase(caseId);
      setState(() {
        _messages = messages;
      });
      _scrollToBottom();
    } catch (e) {
      print('Failed to load messages: $e');
    }
  }

  void _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    final int caseId = widget.myCase.id ?? 0;

    try {
      final message = ChatMessage(
        text: _messageController.text,
        username: _username,
        timestamp: DateTime.now().toUtc(),
      );

      final success = await APIService.sendMessageToCase(caseId, message);
      if (success) {
        setState(() {
          _messages.add(message);
        });
        _messageController.clear();
        _scrollToBottom();
      } else {
        print('Failed to send message');
      }
    } catch (e) {
      print('Failed to send message: $e');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          margin: EdgeInsets.all(24),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Expanded(
                child: _messages.isEmpty
                    ? Center(child: Text('Im Forum gibt es bisher keine Nachrichten...'))
                    : ListView.builder(
                  controller: _scrollController,
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
                        decoration: InputDecoration(labelText: 'Nachricht senden...'),
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
        ),
      ),
    );
  }
}
