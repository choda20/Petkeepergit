import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Welcome"),
      actions: [
        DropdownButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                    child: Row(children: [
                  Icon(Icons.add, color: Colors.blue),
                  Text('Post'),
                ])),
                value: 'Post',
              )
            ],
            onChanged: (itemIdentifier) {}),
        DropdownButton(
          icon: Icon(Icons.more_vert, color: Colors.white),
          items: [
            DropdownMenuItem(
              child: Container(
                  child: Row(
                children: [
                  Icon(
                    Icons.exit_to_app,
                    color: Colors.blue,
                  ),
                  Text('Logout'),
                ],
              )),
              value: 'Logout',
            ),
          ],
          onChanged: (itemIdentifier) {
            if (itemIdentifier == 'Logout') {
              FirebaseAuth.instance.signOut();
            }
          },
        )
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(55);
}
