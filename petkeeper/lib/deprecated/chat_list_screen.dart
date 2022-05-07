import 'package:flutter/material.dart';

class ChatListScreen extends StatelessWidget {
  static const routename = '/chat-list-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
    );
  }
}
