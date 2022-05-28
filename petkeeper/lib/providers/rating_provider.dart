import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/rating.dart';

class RatingProvider with ChangeNotifier {
  List<Rating> _ratings = [];

  Future<void> fetchRatings() async {
    _ratings = [];

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('ratings').get();
    for (var doc in querySnapshot.docs) {
      Rating newRating = Rating(doc['description'], doc['stars'], doc['poster'],
          doc['caretaker'], doc['ratedby'], doc.id, doc['postid']);
      _ratings.add(newRating);
    }
  }

  bool careTakerHasRated(String uid, String postId) {
    final rating = _ratings
        .where((element) => element.ratedBy == uid && element.postId == postId)
        .toList();
    if (rating.isNotEmpty) {
      return true;
    }
    return false;
  }

  bool posterHasRated(String uid, String postId) {
    final rating = _ratings
        .where((element) => element.ratedBy == uid && element.postId == postId)
        .toList();
    if (rating.isNotEmpty) {
      return true;
    }
    return false;
  }

  List<Rating> getUserRatings(String userId) {
    List<Rating> userRatings = _ratings
        .where((element) =>
            element.poster == userId || element.careTaker == userId)
        .toList();
    return userRatings;
  }

  Rating getRating(String postId, String ratedBy) {
    final rating = _ratings.firstWhere(
        (element) => element.postId == postId && element.ratedBy == ratedBy);
    return rating;
  }

  Future<void> addRating(Rating newRating) async {
    late String ratingId;
    final docPath = FirebaseFirestore.instance.collection('ratings').doc();
    await docPath.set({
      'stars': newRating.stars,
      'description': newRating.description,
      'poster': newRating.poster,
      'caretaker': newRating.careTaker,
      'postid': newRating.postId,
      'ratedby': newRating.ratedBy
    }).then((value) => {ratingId = docPath.id});
    newRating.ratingId = ratingId;
    _ratings.add(newRating);
    notifyListeners();
  }

  Future<void> updateRating(Rating updatedRating) async {
    print(updatedRating.ratingId);
    final docPath = FirebaseFirestore.instance
        .collection('ratings')
        .doc(updatedRating.ratingId);
    final ratingIndex = _ratings
        .indexWhere((element) => element.ratingId == updatedRating.ratingId);
    await docPath.update({
      'stars': updatedRating.stars,
      'description': updatedRating.description,
    });
    _ratings[ratingIndex].description = updatedRating.description;
    _ratings[ratingIndex].stars = updatedRating.stars;
    notifyListeners();
  }
}
