import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/post.dart';

class PostsProvider with ChangeNotifier {
  List<Post> _posts = [];

  void fetchPosts() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('posts').get();
    _posts = [];
    for (var doc in querySnapshot.docs) {
      Post newPost = Post(
          userId: doc['userid'],
          dates: doc['dates'],
          postImage: doc['image'],
          title: doc['title'],
          description: doc['description'],
          salary: doc['salary'],
          walks: doc['walks'],
          feeding: doc['feeding'],
          watering: doc['watering']);
      _posts.add(newPost);
    }
  }

  List<Post> get post {
    return [..._posts];
  }
}
