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
  late String _uid;
  late String _name;
  late String _email;
  late String _phoneNumber;

  void submitAuthForm(
    XFile? profilePicture,
    String name,
    String email,
    String phoneNumber,
    String password,
    BuildContext ctx,
    bool isLogin,
    bool isLoading,
  ) async {
    UserCredential authResult;
    try {
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        _uid = authResult.user!.uid;
        await FirebaseStorage.instance
            .refFromURL(
                'gs://petkeeper-7a537.appspot.com/profilePictures/$_uid')
            .putFile(File(profilePicture!.path));
        final url = await FirebaseStorage.instance
            .refFromURL(
                'gs://petkeeper-7a537.appspot.com/profilePictures/$_uid')
            .getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'username': name,
          'email': email,
          'phoneNumber': phoneNumber,
          'downloadurl': url
        });
        _name = name;
        _email = email;
        _phoneNumber = phoneNumber;
      }
      _uid = authResult.user!.uid;
    } on PlatformException catch (err) {
      String? message = 'An error has occurred,please check your credentials';

      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ));
    } catch (err) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(err.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }

  String? get email {
    return _email;
  }

  String? get name {
    return _name;
  }

  Future<void> fetchExtraUserInfo() async {
    _uid = FirebaseAuth.instance.currentUser!.uid;
    var snapshot =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    _name = await snapshot.data()!['username'];
    _email = await snapshot.data()!['email'];
    _phoneNumber = await snapshot.data()!['phoneNumber'];
  }
}
