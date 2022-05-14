import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:petkeeper/models/post.dart';
import '../widgets/post_item.dart';
import 'package:petkeeper/providers/posts_provider.dart';
import 'package:provider/provider.dart';

class UserListings extends StatelessWidget {
  static const routename = '/listings-screen';

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final postprovider = Provider.of<PostsProvider>(context).post;
    List<Post> userPosts =
        postprovider.where((element) => element.userId == uid).toList();
    return Scaffold(
      appBar: AppBar(
          title: const Text('Your listings'),
          flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: <Color>[Color(0xfffe5858), Color(0xffee9617)])))),
      body: ListView.builder(
          itemCount: userPosts.length,
          padding: const EdgeInsets.only(bottom: 10, top: 10),
          itemBuilder: (BuildContext ctx, index) {
            return PostItem(userPosts[index], true);
          }),
    );
  }
}
