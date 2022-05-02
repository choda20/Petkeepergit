import 'package:flutter/material.dart';
import 'package:petkeeper/models/post.dart';
import 'package:petkeeper/widgets/post_screen_args.dart';

class PostScreen extends StatelessWidget {
  static const routename = '/post-screen';
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PostScreenArgs;
    return Scaffold(
      appBar: AppBar(
        title: Text(args.postData.title),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/profile-screen');
                  },
                  child: const Icon(
                    Icons.person,
                    size: 30.0,
                  ))),
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/chat-screen');
                  },
                  child: const Icon(
                    Icons.chat_rounded,
                    size: 26.0,
                  ))),
        ],
      ),
      body: Text(args.postData.title),
    );
  }
}
