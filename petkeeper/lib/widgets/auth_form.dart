import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petkeeper/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/AppDrawer.dart';

class AuthForm extends StatefulWidget {
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String? _userEmail = '';
  String? _userName = '';
  String? _userPassword = '';
  bool _isLogin = false;

  bool verifyPasswords(String? password, String? password2) {
    if (password == password2 && password != null && password2 != null) {
      return true;
    }
    return false;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (isValid != null && isValid) {
      _formKey.currentState?.save();
      setState(() {
        _isLoading = !_isLoading;
      });
      Provider.of<AuthProvider>(context, listen: false).submitAuthForm(
        _userName!.trim(),
        _userEmail!.trim(),
        _userPassword!.trim(),
        context,
        _isLogin,
        _isLoading,
      );
      setState(() {
        _isLoading = !_isLoading;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Invalid Inputs'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
                  if (!_isLogin)
                    TextFormField(
                        key: const ValueKey('username'),
                        validator: (value) {
                          if (value == null || value == '') {
                            return 'Please enter a Username.';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white))),
                        style: const TextStyle(color: Colors.white),
                        onSaved: (value) {
                          _userName = value;
                        },
                        keyboardType: TextInputType.name),
                  TextFormField(
                    key: const ValueKey('email'),
                    validator: (value) {
                      if (value == null ||
                          !value.contains('@') ||
                          value == '') {
                        return 'Please enter a valid Email address.';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white))),
                    style: const TextStyle(color: Colors.white),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextFormField(
                      key: const ValueKey('password'),
                      validator: (value) {
                        if (value == null || value.length < 7) {
                          return 'Please enter a Password that is at least 7 characters long.';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                      style: const TextStyle(color: Colors.white),
                      onSaved: (value) {
                        _userPassword = value;
                      }),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('passwordcheck'),
                      validator: (value) {
                        bool check = verifyPasswords(value, _userPassword);
                        if (check == false) {
                          return 'Unmatching passwords';
                        }
                        if (value == null || value.length < 7) {
                          return 'Please enter a Password that is at least 7 characters long.';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                      style: const TextStyle(color: Colors.white),
                    ),
                  if (!_isLoading)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                          ),
                          onPressed: _trySubmit,
                          child: Text(_isLogin ? 'Login' : 'Sign up'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Text(_isLogin ? 'Sign up' : 'Login'),
                        ),
                      ],
                    ),
                  if (_isLoading) const CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ),
      ),
    ]));
  }
}
