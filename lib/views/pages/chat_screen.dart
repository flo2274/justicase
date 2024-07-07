import 'package:flutter/material.dart';
import 'package:mobile_anw/models/chat_message.dart'; // Korrekter Importpfad zur ChatMessage-Klasse
import 'package:mobile_anw/services/api_service.dart'; // Korrekter Importpfad zum APIService

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<ChatMessage> _messages = []; // Liste für ChatMessage-Objekte

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index].text),
                  subtitle: Text('${_messages[index].sender} - ${_messages[index].timestamp}'),
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
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _sendMessage,
                  child: Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    final int caseId = 1; // Beispiel für die Fall-ID

    final message = ChatMessage(
      text: _messageController.text,
      sender: 'Me',
      timestamp: DateTime.now(),
    );

    final success = await APIService.sendMessage(caseId, message); // Aufruf der API für den Nachrichtenversand
    if (success) {
      setState(() {
        _messages.insert(0, message); // Nachricht zur Liste hinzufügen
      });
      _messageController.clear(); // Textfeld leeren nach dem Senden
    } else {
      // Behandlung bei Fehlschlag des Nachrichtenversands
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Failed to send message'),
          content: Text('An error occurred while sending the message.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      print('Failed to send message');
    }
  }
}
