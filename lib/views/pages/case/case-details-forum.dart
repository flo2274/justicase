import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/models/chat_message.dart';
import 'package:mobile_anw/services/api_service.dart';
import '../../../utils/configs/theme_config.dart';
import '../../../utils/user_preferences.dart';
import '../../items/message-bubble_item.dart';

class CaseDetailsForum extends StatefulWidget {
  final Case myCase;

  const CaseDetailsForum({
    super.key,
    required this.myCase
  });

  @override
  CaseDetailsForumState createState() => CaseDetailsForumState();
}

class CaseDetailsForumState extends State<CaseDetailsForum> {
  List<ChatMessage> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late String _username;
  late Timer _timer;
  bool _isUserDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _startMessageLoading();
  }

  void _startMessageLoading() {
    _timer = Timer.periodic(const Duration(seconds: 10), (Timer t) {
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
        _username = username;
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fehler beim Laden der Nachrichten'),
          backgroundColor: Colors.red,
        ),
      );
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fehler beim Senden der Nachricht'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Senden der Nachricht: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
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
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Expanded(
                child: _messages.isEmpty
                    ? const Center(child: Text('Im Forum gibt es bisher keine Nachrichten...'))
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
                        decoration: const InputDecoration(labelText: 'Nachricht senden...'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.send, color: ThemeConfig.darkGreyAccent,),
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
