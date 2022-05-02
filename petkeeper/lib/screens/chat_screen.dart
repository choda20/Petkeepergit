import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  static const routename = '/chat-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Screen')),
    );
  }
}
