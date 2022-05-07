import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AuthProvider with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  late final User user = _auth.currentUser!;
  late String _uid = user.uid;
  String? _name;
  String? _email;

  void submitAuthForm(
    Image profilePicture,
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
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({'username': name, 'email': email});
        await FirebaseStorage.instance
            .ref()
            .child('profilePictures/$_uid')
            .putFile(File(profilePicture.toString()));
      }
      _uid = authResult.user!.uid;
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

  String? get email {
    return _email;
  }

  String? get name {
    return _name;
  }

  Future<void> fetchExtraUserInfo() async {
    var snapshot =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    _name = await snapshot.data()!['username'];
    _email = await snapshot.data()!['email'];
  }
}
