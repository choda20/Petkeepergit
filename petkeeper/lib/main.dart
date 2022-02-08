//package imports
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// file imports
import 'widgets/AppDrawer.dart';
import 'Screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PetKeeper",
      home: Container(
        decoration: BoxDecoration(
          gradient: (LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromRGBO(102, 102, 255, 80),
                Color.fromRGBO(102, 178, 255, 20)
              ])),
        ),
        child: AuthScreen(),
      ),
    );
  }
}
