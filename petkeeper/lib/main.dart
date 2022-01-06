//package imports
import 'package:flutter/material.dart';
// file imports
import 'widgets/AppDrawer.dart';
import 'Screens/AuthScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  var color1 = Color.fromRGBO(102, 102, 255, 80);
  var color2 = Color.fromRGBO(102, 178, 255, 20);
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PetKeeper",
      home: Container(
        decoration: BoxDecoration(
          gradient: (LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [color1, color2])),
        ),
        child: AuthScreen(),
      ),
    );
  }
}
