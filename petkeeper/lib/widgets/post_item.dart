import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:petkeeper/screens/post_screen.dart';
import 'package:petkeeper/widgets/post_screen_args.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/auth_provider.dart';
import 'package:petkeeper/models/post.dart';

class PostItem extends StatelessWidget {
  PostItem(this.postData);
  Post postData;
  @override
  Widget build(BuildContext context) {
    String imageUrl = postData.postImage;
    String title = postData.title;
    final _firebaseStorage =
        FirebaseStorage.instance.ref().child('images/$imageUrl+$title');

    return GestureDetector(
      child: FutureBuilder<String>(
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          Widget imageDisplay;
          if (snapshot.connectionState == ConnectionState.done) {
            imageDisplay = Image.network(snapshot.data.toString());
          } else {
            imageDisplay = const CircularProgressIndicator();
          }
          return Padding(padding: const EdgeInsets.all(5), child: imageDisplay);
        },
        future: _firebaseStorage.getDownloadURL(),
      ),
      onTap: () {
        Navigator.of(context)
            .pushNamed('/post-screen', arguments: PostScreenArgs(postData));
      },
    );
  }
}
