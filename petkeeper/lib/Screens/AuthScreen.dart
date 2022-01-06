import 'package:flutter/material.dart';

import '../widgets/AppDrawer.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      backgroundColor: Colors.transparent,
      body: Center(
          child: Column(children: [
        SizedBox(
            height: 325,
            width: 200,
            child: Image.network(
                'https://i.pinimg.com/originals/c1/2d/af/c12daffa996683fe1080c809aca58e23.png')),
        Card(
          margin: EdgeInsets.only(left: 30, right: 30),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                      decoration: InputDecoration(labelText: 'Username'),
                      keyboardType: TextInputType.name),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromRGBO(0, 128, 255, 50))),
                        onPressed: () {},
                        child: Text('Sign up'),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text('Login'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ])),
    );
  }
}
