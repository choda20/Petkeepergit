import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petkeeper/widgets/widget_args/profile_screen_args.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/posts_provider.dart';

class AppDrawer extends StatelessWidget {
  var _isLoading = true;

  @override
  Widget build(BuildContext context) {
    if (Provider.of<AuthProvider>(context).name == null) {
      _isLoading = true;
    } else {
      _isLoading = false;
    }
    final uid = Provider.of<AuthProvider>(context).user.uid;
    final url = FirebaseStorage.instance
        .refFromURL('gs://petkeeper-7a537.appspot.com/profilePictures/$uid')
        .getDownloadURL();
    return _isLoading
        ? const CircularProgressIndicator()
        : Drawer(
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: <Color>[Color(0xfffe5858), Color(0xffee9617)])),
              child: Column(
                children: [
                  const SizedBox(height: 45),
                  FutureBuilder(
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      Widget imageDisplay;
                      if (snapshot.connectionState == ConnectionState.done) {
                        imageDisplay = Image.network(
                          snapshot.data.toString(),
                          fit: BoxFit.cover,
                        );
                      } else {
                        imageDisplay = const CircularProgressIndicator();
                      }
                      return ClipOval(
                        child: SizedBox(
                            height: 150, width: 150, child: imageDisplay),
                      );
                    },
                    future: url,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Provider.of<AuthProvider>(context).name!,
                      style: const TextStyle(fontSize: 35, color: Colors.white),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.house, color: Colors.white),
                    title: const Text(
                      'Home',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed('/home-screen');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.account_box, color: Colors.white),
                    title: const Text(
                      'Account',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed('/profile-screen',
                          arguments: ProfileScreenArgs(uid));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.assignment, color: Colors.white),
                    title: const Text(
                      'Listings',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed('/listings-screen');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.work, color: Colors.white),
                    title: const Text(
                      'Jobs',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.white),
                    title: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                    },
                  ),
                ],
              ),
            ),
          );
  }
}
