import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../screens/screen_args/profile_screen_args.dart';

class AppDrawer extends StatelessWidget {
  var _isLoading = true;

  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<AuthProvider>(context).user.uid;
    final userData = Provider.of<UserProvider>(context).getUserData(uid);
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: <Color>[Color(0xfffe5858), Color(0xffee9617)])),
        child: Column(
          children: [
            const SizedBox(height: 45),
            CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(userData.downloadurl)),
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
                Navigator.of(context).pushReplacementNamed('/home-screen');
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
              onTap: () {
                Navigator.of(context).pushNamed('/jobs-screen');
              },
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
