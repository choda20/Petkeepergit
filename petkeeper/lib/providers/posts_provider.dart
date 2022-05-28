import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../models/filter.dart';
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
          downloadUrl: doc['downloadurl'],
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
    final url = await FirebaseStorage.instance
        .ref()
        .child('images/$postId')
        .getDownloadURL();
    newPost.downloadUrl = url;
    await FirebaseFirestore.instance.collection('posts').doc(postId).update({
      'downloadurl': url,
    });
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
        .update({
      'petNum': newPost.petNum,
      'downloadurl': _posts[postIndex].downloadUrl,
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

  List<Post> filterResults(Filter filter, List<Post> unFilteredPosts) {
    bool waterReset = false;
    bool petReset = false;
    bool walksReset = false;
    bool foodReset = false;
    bool startingDateReset = false;
    bool endingDateReset = false;
    List<Post> _filtered = [];
    bool inDateRange(DateTime filterStartingDate, DateTime filterEndingDate,
        DateTime postStartingDate, DateTime postEndingDate) {
      if (filterStartingDate.isBefore(postStartingDate) &&
              filterEndingDate.isAfter(postEndingDate) ||
          filterStartingDate == postStartingDate &&
              filterEndingDate == postEndingDate ||
          filterStartingDate == postStartingDate &&
              filterEndingDate.isAfter(postEndingDate) ||
          filterStartingDate.isBefore(postStartingDate) &&
              filterEndingDate == postEndingDate) {
        return true;
      }
      return false;
    }

    for (var post in unFilteredPosts) {
      if (filter.petsValue == 7) {
        filter.petsValue = post.petNum;
        petReset = true;
      }
      if (filter.waterValue == 7) {
        filter.waterValue = post.watering;
        waterReset = true;
      }
      if (filter.walksValue == 7) {
        filter.walksValue = post.walks;
        walksReset = true;
      }
      if (filter.foodValue == 7) {
        filter.foodValue = post.feeding;
        foodReset = true;
      }
      if (filter.startingDate == '') {
        filter.startingDate = post.startingDate;
        startingDateReset = true;
      }
      if (filter.endingDate == '') {
        filter.endingDate = post.endingDate;
        endingDateReset = true;
      }
      DateTime filterStartingDate = DateTime.parse(filter.startingDate);
      DateTime filterEndingDate = DateTime.parse(filter.endingDate);
      DateTime postStartingDate = DateTime.parse(post.startingDate);
      DateTime postEndingDate = DateTime.parse(post.endingDate);
      if (post.feeding == filter.foodValue &&
          post.walks == filter.walksValue &&
          post.petNum == filter.petsValue &&
          post.watering == filter.waterValue &&
          post.salary >= filter.startingSalaryValue &&
          inDateRange(filterStartingDate, filterEndingDate, postStartingDate,
              postEndingDate)) {
        _filtered.add(post);
      }
      if (waterReset) {
        filter.waterValue = 7;
      }
      if (foodReset) {
        filter.foodValue = 7;
      }
      if (walksReset) {
        filter.walksValue = 7;
      }
      if (petReset) {
        filter.petsValue = 7;
      }
      if (startingDateReset) {
        filter.startingDate = '';
      }
      if (endingDateReset) {
        filter.endingDate = '';
      }
    }
    return _filtered;
  }

  List<Post> getPostsById(List<String> postIds) {
    List<Post> posts = [];
    int index = -1;
    for (var postId in postIds) {
      index = _posts.indexWhere((element) => element.postId == postId);
      if (index != -1) {
        posts.add(_posts[index]);
      }
    }
    return posts;
  }

  List<Post> getUserPosts(String userId) {
    List<Post> userPosts =
        _posts.where((element) => element.userId == userId).toList();
    return userPosts;
  }

  List<Post> getPastPosts(List<Post> postList) {
    List<Post> pastPosts = [];
    for (var post in postList) {
      DateTime endDate = DateTime.parse(post.endingDate);
      if (endDate.isBefore(DateTime.now())) {
        pastPosts.add(post);
      }
    }
    return pastPosts;
  }

  List<Post> getOngingPosts(List<Post> postList) {
    List<Post> ongingPosts = [];
    for (var post in postList) {
      DateTime endDate = DateTime.parse(post.endingDate);
      if (endDate.isAfter(DateTime.now())) {
        ongingPosts.add(post);
      }
    }
    return ongingPosts;
  }
}
