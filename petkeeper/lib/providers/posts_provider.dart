import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../models/post.dart';

class PostsProvider with ChangeNotifier {
  List<Post> _posts = [];

  Future<void> fetchPosts() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('posts').get();
    _posts = [];
    for (var doc in querySnapshot.docs) {
      Post newPost = Post(
          postId: doc.id,
          petNum: doc['petNum'],
          userId: doc['userid'],
          startingDate: doc['startingdate'],
          endingDate: doc['endingdate'],
          title: doc['title'],
          description: doc['description'],
          salary: doc['salary'],
          walks: doc['walks'],
          feeding: doc['feeding'],
          watering: doc['watering']);
      _posts.add(newPost);
    }
  }

  void replaceImage(XFile postImage, String postId) async {
    await FirebaseStorage.instance
        .refFromURL('gs://petkeeper-7a537.appspot.com/images/$postId')
        .delete();
    await FirebaseStorage.instance
        .refFromURL('gs://petkeeper-7a537.appspot.com/images/$postId')
        .putFile(File(postImage.path));
    notifyListeners();
  }

  List<Post> get post {
    return [..._posts];
  }

  void deleteListing(String postId) async {
    final postIndex = _posts.indexWhere((element) {
      return element.postId == postId;
    });
    _posts.remove(_posts[postIndex]);
    await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
    notifyListeners();
  }

  void addPost(Post newPost, XFile postImage) async {
    late String postId;
    final docPath = FirebaseFirestore.instance.collection('posts').doc();
    await docPath.set({
      'petNum': newPost.petNum,
      'title': newPost.title,
      'startingdate': newPost.startingDate,
      'endingdate': newPost.endingDate,
      'salary': newPost.salary,
      'description': newPost.description,
      'walks': newPost.walks,
      'feeding': newPost.feeding,
      'watering': newPost.watering,
      'userid': newPost.userId
    }).then((value) {
      postId = docPath.id;
    });
    await FirebaseStorage.instance
        .ref()
        .child('images/$postId')
        .putFile(File(postImage.path));
    newPost.postId = postId;
    _posts.add(newPost);
    notifyListeners();
  }

  void changePost(Post newPost, String postId) async {
    final postIndex = _posts.indexWhere((element) {
      return element.postId == postId;
    });
    _posts[postIndex].startingDate = newPost.startingDate;
    _posts[postIndex].endingDate = newPost.endingDate;
    _posts[postIndex].description = newPost.description;
    _posts[postIndex].feeding = newPost.feeding;
    _posts[postIndex].petNum = newPost.petNum;
    _posts[postIndex].watering = newPost.watering;
    _posts[postIndex].salary = newPost.salary;
    _posts[postIndex].title = newPost.title;
    _posts[postIndex].walks = newPost.walks;
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(newPost.postId)
        .set({
      'petNum': newPost.petNum,
      'title': newPost.title,
      'startingdate': newPost.startingDate,
      'endingdate': newPost.endingDate,
      'salary': newPost.salary,
      'description': newPost.description,
      'walks': newPost.walks,
      'feeding': newPost.feeding,
      'watering': newPost.watering,
      'userid': newPost.userId,
    });
    notifyListeners();
  }

  List<Post> filterResults(
      int petNum, int waterNum, int foodNum, int walksNum) {
    List<Post> filtered = _posts
        .where((element) =>
            element.petNum == petNum &&
            element.feeding == foodNum &&
            element.walks == walksNum &&
            element.watering == waterNum)
        .toList();
    return filtered;
  }

  List<Post> getUserPosts(String userId) {
    List<Post> userPosts =
        _posts.where((element) => element.userId == userId).toList();
    return userPosts;
  }
}
