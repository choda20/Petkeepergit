import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../providers/auth_provider.dart';
import '../widgets/gradient_button.dart';

class AuthForm extends StatefulWidget {
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String? _userEmail = '';
  String? _userName = '';
  String _phoneNumber = '';
  String? _userPassword = '';
  bool _isLogin = false;
  XFile? _storedImage;
  Image defaultImage = Image.asset('assets/A4RnHy7isSNmUEaBpbhl.jpg');

  Future<void> _choosePicture() async {
    final imageFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxWidth: 250, maxHeight: 250);
    setState(() {
      _storedImage = imageFile!;
    });
  }

  bool verifyPasswords(String? password, String? password2) {
    if (password == password2 && password != null && password2 != null) {
      return true;
    }
    return false;
  }

  void _trySubmit() {
    _formKey.currentState?.save();
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (isValid != null &&
            isValid &&
            _storedImage != null &&
            _isLogin == false ||
        isValid != null && isValid && _isLogin == true) {
      setState(() {
        _isLoading = !_isLoading;
      });
      Provider.of<AuthProvider>(context, listen: false).submitAuthForm(
        _storedImage,
        _userName!.trim(),
        _userEmail!.trim(),
        _phoneNumber.trim(),
        _userPassword!.trim(),
        context,
        _isLogin,
        _isLoading,
      );
      setState(() {
        _isLoading = !_isLoading;
      });
    }
    if (_storedImage == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please choose an Image'),
          backgroundColor: Colors.red));
    }
  }

  bool isNumeric(String num) {
    return int.tryParse(num) != null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
          child: Column(children: [
        const SizedBox(height: 75),
        !_isLogin
            ? CircleAvatar(
                child: GestureDetector(onTap: _choosePicture),
                radius: 100,
                backgroundImage: _storedImage == null
                    ? defaultImage.image
                    : Image.file(File(_storedImage!.path)).image,
              )
            : const SizedBox(height: 150),
        const SizedBox(height: 25),
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
                              return 'Please enter a username.';
                            }
                            if (value.length > 10) {
                              return 'a usernames maximun length is 10 characters';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              errorStyle: TextStyle(color: Colors.white),
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
                          errorStyle: TextStyle(color: Colors.white),
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
                    if (!_isLogin)
                      TextFormField(
                        key: const ValueKey('phoneNumber'),
                        validator: (value) {
                          if (value == null || !isNumeric(value)) {
                            return 'Please enter a valid phone number.';
                          }
                          if (value.length > 11) {
                            return 'a phone numbers maximun length is 10 characters';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            errorStyle: TextStyle(color: Colors.white),
                            labelText: 'Phone number',
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white))),
                        style: const TextStyle(color: Colors.white),
                        onSaved: (value) {
                          _phoneNumber = value!;
                        },
                        keyboardType: TextInputType.number,
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
                            errorStyle: TextStyle(color: Colors.white),
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
                            errorStyle: TextStyle(color: Colors.white),
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white))),
                        style: const TextStyle(color: Colors.white),
                      ),
                    const SizedBox(height: 15),
                    if (!_isLoading)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GradientButton(
                              _trySubmit,
                              _isLogin ? 40 : 40,
                              _isLogin ? 80 : 100,
                              Icons.upload,
                              _isLogin ? 'Login' : 'Sign up',
                              15),
                          const SizedBox(width: 10),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: GradientText(
                              _isLogin ? 'Sign up' : 'Login',
                              colors: const [
                                Color(0xfffe5858),
                                Color(0xffee9617)
                              ],
                            ),
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
      ])),
    );
  }
}
