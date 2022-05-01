import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:petkeeper/screens/post_screen.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/auth_provider.dart';
import 'package:petkeeper/models/post.dart';

class PostItem extends StatelessWidget {
  PostItem(this.postdata);
  Post postdata;
  @override
  Widget build(BuildContext context) {
    print(postdata.imageUrl.toString());
    return GestureDetector(
      child: FittedBox(
        fit: BoxFit.fill,
        child: Image.network(postdata.imageUrl.toString()),
      ),
      onTap: () {
        PostScreen();
      },
    );
  }
}
