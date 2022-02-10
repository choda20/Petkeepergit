import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './new_post_screen.dart';
import '../widgets/AppDrawer.dart';
import '../widgets/MyAppBar.dart';

class homeScreen extends StatelessWidget {
  static const routename = '/home-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('PetKeeper'),
        ),
        drawer: AppDrawer(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed('/new_post-screen');
          },
        ),
        body: GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: 1,
            itemBuilder: (BuildContext ctx, index) {
              return Container(child: Text('helljo'));
            }));
  }
}
