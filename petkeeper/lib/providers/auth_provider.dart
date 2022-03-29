import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

class AuthP with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  String _name = '';
  String _email = '';

  String? get name {
    return _name;
  }

  String? get email {
    return _email;
  }

  void submitAuthForm(
    String? name,
    String? email,
    String? password,
    BuildContext ctx,
    bool isLogin,
    bool isLoading,
  ) async {
    UserCredential authResult;
    try {
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email!, password: password!);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email!, password: password!);
      }
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user!.uid)
          .set({'username': name, 'email': email});
    } on PlatformException catch (err) {
      String? message = 'An error has occurred,please check your credentials';
      if (err.message != null) {
        message = err.message;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message!),
        backgroundColor: Colors.red,
      ));
    } catch (err) {
      print(err);
    }
  }
}
