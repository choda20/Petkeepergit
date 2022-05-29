import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AuthProvider with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  late User user;
  late String _uid;
  late String _username;
  late String _email;
  late String _profilePictureUrl;
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
  ) {
    try {
      if (isLogin) {
        _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((authResult) {
          _uid = authResult.user!.uid;
          user = authResult.user!;
        });
      } else {
        _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((authResult) {
          _uid = authResult.user!.uid;
          user = authResult.user!;
          FirebaseStorage.instance
              .refFromURL(
                  'gs://petkeeper-7a537.appspot.com/profilePictures/$_uid')
              .putFile(File(profilePicture!.path))
              .then((fileRef) {
            fileRef.ref.getDownloadURL().then((value) {
              FirebaseFirestore.instance.collection('users').doc(_uid).set({
                'username': name,
                'email': email,
                'phoneNumber': phoneNumber,
                'downloadurl': value
              });
              _username = name;
              _email = email;
              _phoneNumber = phoneNumber;
            });
          });
        });
      }
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
    return _username;
  }

  Future<void> fetchExtraUserInfo() async {
    _uid = _auth.currentUser!.uid;
    user = _auth.currentUser!;
    var snapshot =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    _username = snapshot.data()!['username'];
    _email = snapshot.data()!['email'];
    _phoneNumber = snapshot.data()!['phoneNumber'];
    _profilePictureUrl = snapshot.data()!['downloadurl'];
  }
}
