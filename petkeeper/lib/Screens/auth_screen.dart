import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/AppDrawer.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _userEmail = '';
  String? _userName = '';
  String? _userPassword = '';

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (isValid != null && isValid) {
      _formKey.currentState?.save();
    } else {
      print('is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          color: Colors.transparent,
          margin: const EdgeInsets.only(left: 30, right: 30),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter a Username.';
                          }
                          return null;
                        },
                        decoration:
                            const InputDecoration(labelText: 'Username'),
                        onSaved: (value) {
                          _userName = value;
                        },
                        keyboardType: TextInputType.name),
                    TextFormField(
                      validator: (value) {
                        if (value == null || !value.contains('@')) {
                          return 'Please enter a valid Email address.';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'Email'),
                      onSaved: (value) {
                        _userEmail = value;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextFormField(
                        validator: (value) {
                          if (value == null || value.length < 7) {
                            return 'Please enter a Password that is at least 7 characters long.';
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                        onSaved: (value) {
                          _userPassword = value;
                        }),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.length < 7) {
                          return 'Please enter a Password that is at least 7 characters long.';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration:
                          const InputDecoration(labelText: 'Confirm Password'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                          ),
                          onPressed: _trySubmit,
                          child: const Text('Sign up'),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Login'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ])),
    );
  }
}
