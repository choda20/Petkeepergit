import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/rating.dart';

class RatingProvider with ChangeNotifier {
  List<Rating> _ratings = [];

  // טענת כניסה: אין
  // _ratings טענת יציאה: הפעולה שולפת את הנתונים המאוחסנים בקולקציית הדירוגים ומאחסנת אותם ברשימת הדירוגים המקומית
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

  // טענת כניסה: הפעולה מקבלת מזהה של משתמש ומזהה של פוסט
  // טענת יציאה: הפעולה בודקת אם קיים ברשימת הדירוגים דירוג לפוסט שסופק המזהה שלו בו המשתמש שסופק המזהה שלו הוא המטפל והמדרג
  // "במידה וקיים דירוג כזה הפעולה מחזירה "אמת", במידה ולא תחזיר הפעולה "שקר
  bool careTakerHasRated(String uid, String postId) {
    final rating = _ratings
        .where((element) => element.ratedBy == uid && element.postId == postId)
        .toList();
    if (rating.isNotEmpty) {
      return true;
    }
    return false;
  }

  // טענת כניסה: הפעולה מקבלת מזהה של משתמש ומזהה של פוסט
  // טענת יציאה: הפעולה בודקת אם קיים ברשימת הדירוגים דירוג לפוסט שסופק המזהה שלו בו המשתמש שסופק המזהה שלו הוא המפרסם והמדרג
  // "במידה וקיים דירוג כזה הפעולה מחזירה "אמת", במידה ולא תחזיר הפעולה "שקר
  bool posterHasRated(String uid, String postId) {
    final rating = _ratings
        .where((element) => element.ratedBy == uid && element.postId == postId)
        .toList();
    if (rating.isNotEmpty) {
      return true;
    }
    return false;
  }

  // טענת כניסה: הפעולה מקבלת מזהה של מתשמש
  //  טענת יציאה: הפעולה מחזיה את הדירוגים הקשורים למשתמש, כלומר דירוגים בהם הוא המטפל או המפרסם
  List<Rating> getUserRatings(String userId) {
    List<Rating> userRatings = _ratings
        .where((element) =>
            element.poster == userId || element.careTaker == userId)
        .toList();
    return userRatings;
  }

  // טענת כניסה: הפעולה מקבלת מזהה פוסט ומחרוזת המכילה את מזהה המדרג
  // טענת יציאה: הפעולה מחזירה דירוג בו המדרג הוא המשתמש שסופק המזהה שלו והפוסט עליו ניתן
  // הדירוג הוא הפוסט שסופק המזהה שלו
  Rating getRating(String postId, String ratedBy) {
    final rating = _ratings.firstWhere(
        (element) => element.postId == postId && element.ratedBy == ratedBy);
    return rating;
  }

  // טענת כניסה: הפעולה מקבלת משתנה מסוג  דירוג המאחסן דירוג חדש
  // טענת יציאה: הפעולה מוסיפה את הדירוג לקולקציית הדירוגים במסד הנתונים ולאחר מכן מוסיפה
  // אותו לרשימה המקומית ומתריעה על כך למאזינים
  void addRating(Rating newRating) {
    late String ratingId;
    final docPath = FirebaseFirestore.instance.collection('ratings');
    docPath.add({
      'stars': newRating.stars,
      'description': newRating.description,
      'poster': newRating.poster,
      'caretaker': newRating.careTaker,
      'postid': newRating.postId,
      'ratedby': newRating.ratedBy
    }).then((value) {
      ratingId = value.id;
      newRating.ratingId = ratingId;
      _ratings.add(newRating);
      notifyListeners();
    });
  }

  // טענת כניסה: הפעולה מקבלת משתנה מסוג דירוג המאחסן דירוג מעודכן
  // טענת יציאה: הפעולה מעדכנת את הדירוג במסד הנתונים ולאחר מכן
  // מעדכנת אותו ברשימה המקומית ומתריעה על כך למאזינים
  void updateRating(Rating updatedRating) {
    final docPath = FirebaseFirestore.instance
        .collection('ratings')
        .doc(updatedRating.ratingId);
    final ratingIndex = _ratings
        .indexWhere((element) => element.ratingId == updatedRating.ratingId);
    docPath.update({
      'stars': updatedRating.stars,
      'description': updatedRating.description,
    }).then((value) {
      _ratings[ratingIndex].description = updatedRating.description;
      _ratings[ratingIndex].stars = updatedRating.stars;
      notifyListeners();
    });
  }
}
