import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static const routename = '/profile-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your profile')),
      body: Container(
        height: 300,
        width: 400,
        child: FittedBox(
          fit: BoxFit.fill,
          child: Image.network(
              'https://kirby.nintendo.com/assets/img/home/kirby-pink.png'),
        ),
      ),
    );
  }
}
