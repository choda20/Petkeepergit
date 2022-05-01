import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  var _isLoading = true;
  @override
  Widget build(BuildContext context) {
    if (Provider.of<AuthProvider>(context).name == null) {
      _isLoading = true;
    } else {
      _isLoading = false;
    }

    return _isLoading
        ? const CircularProgressIndicator()
        : Drawer(
            child: Column(
              children: [
                AppBar(
                    automaticallyImplyLeading: false,
                    title: Text('Welcome ' +
                        Provider.of<AuthProvider>(context, listen: false)
                            .name!)),
                ListTile(
                  leading: const Icon(Icons.account_box),
                  title: const Text('Account'),
                  onTap: () {
                    Navigator.of(context).pushNamed('/profile-screen');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                  },
                ),
              ],
            ),
          );
  }
}
