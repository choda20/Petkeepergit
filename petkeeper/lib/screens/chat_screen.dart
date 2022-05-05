import 'package:flutter/material.dart';
import 'package:petkeeper/widgets/widget_args/chat_screen_args.dart';

class ChatScreen extends StatelessWidget {
  static const routename = '/chat-screen';
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ChatScreenArgs;
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Screen')),
    );
  }
}
