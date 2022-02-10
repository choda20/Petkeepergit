import 'package:flutter/material.dart';

class NewPost extends StatelessWidget {
  static const routename = '/new_post-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a new post'),
      ),
    );
  }
}
