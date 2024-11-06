import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<dynamic> messages = [];
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  // Fetch messages from API
Future<void> fetchMessages() async {
  print('\n\nFetching messages...');
  final response = await http.get(Uri.parse('https://admin.goffix.com/api/messages/send.php'));

  if (response.statusCode == 200) {
    // Decode the response
    final decodedResponse = json.decode(response.body);
    
    // Check if the response contains the "messages" key
    if (decodedResponse is Map<String, dynamic> && decodedResponse.containsKey('messages')) {
      setState(() {
        messages = decodedResponse['messages']; // Extract messages list
      });
    } else {
      print('Unexpected response format');
    }
  } else {
    print('Failed to load messages');
  }
}


  // Send a new message
  Future<void> sendMessage(String content) async {
    final response = await http.post(
      Uri.parse('https://admin.goffix.com/api/messages/send.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "m_pid": 1,
        "m_sid": 8,
        "m_rid": 9,
        "m_content": content,
        "m_dt": DateTime.now().toString(),
        "m_read_stat": "UNREAD",
        "m_type": "text",
        "m_media_url": null,
        "m_body": "This is the body of the message."
      }),
    );

    if (response.statusCode == 200) {
      print('message send');
      fetchMessages();
      _messageController.clear();
    } else {
      print('Failed to send message');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                bool isSentByUser = message['m_sid'] == "8";  // Check if sender is the user

                return Align(
                  alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSentByUser ? Colors.blueAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['m_content'] ?? '',
                          style: TextStyle(color: isSentByUser ? Colors.white : Colors.black),
                        ),
                        Text(
                          message['m_dt'] ?? '',
                          style: TextStyle(color: Colors.black54, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
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
                      hintText: 'Type a message',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      sendMessage(_messageController.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
