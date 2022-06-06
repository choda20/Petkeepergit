import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:petkeeper/models/user.dart';

class UserProvider with ChangeNotifier {
  List<User> _userList = [];

  // טענת כניסה: אין
  // _userList טענת יציאה: הפעולה שולפת את המידע המאוחסן בקולקציית המשתמשים ומאחסנת אותו ברשימה המקומית
  Future<void> fetchUsersData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    _userList = [];
    for (var doc in querySnapshot.docs) {
      User newUser = User(doc['username'], doc['email'], doc['phoneNumber'],
          doc.id, doc['downloadurl']);
      _userList.add(newUser);
    }
  }

  // טענת כניסה: הפעולה מקבלת משתנה מסוג משתמש ותמונה
  // טענת יציאה: הפעולה מוחקת את התמונה הנוכחית של המשתמש ממסד הנתונים ומעלה תמונה חדשה במקומה
  // בנוסף, הפעולה מגדירה למשתמש תמונה זמנית עד שהתמונה החדשה תועלה למסד הנתונים. לבסוף מעדכנת הפעולה
  // updateUserData את הקישור להורדת תמונת הפרופיל בקישורה של התמונה החדשה ומעבירה את משתנה המשתמש שסופק לה לפעולה
  void replaceImage(User user, XFile image) {
    final userIndex =
        _userList.indexWhere((element) => element.userId == user.userId);
    _userList[userIndex].downloadurl =
        'https://firebasestorage.googleapis.com/v0/b/petkeeper-7a537.appspot.com/o/empty.jpg?alt=media&token=a653f578-0fff-4ef1-ab35-40fbd355c534';
    notifyListeners();
    FirebaseStorage.instance
        .refFromURL(
            'gs://petkeeper-7a537.appspot.com/profilePictures/${user.userId}')
        .delete()
        .then((value) {
      FirebaseStorage.instance
          .refFromURL(
              'gs://petkeeper-7a537.appspot.com/profilePictures/${user.userId}')
          .putFile(File(image.path))
          .then((refrence) {
        refrence.ref.getDownloadURL().then((value) {
          _userList[userIndex].downloadurl = value;
          updateUserData(user);
        });
      });
    });
  }

  // טענת כניסה: הפעולה מקבלת משתנה מסוג משתמש
  // טענת יציאה: הפעולה מעדכנת את פרטי המשתמש במסד הנתונים ולאחר מכן ברשימה המקומית ואז מתריעה על כך למאזינים
  void updateUserData(User user) {
    final userIndex =
        _userList.indexWhere((element) => element.userId == user.userId);
    _userList[userIndex].email = user.email;
    _userList[userIndex].phoneNumber = user.phoneNumber;
    _userList[userIndex].userName = user.userName;
    FirebaseFirestore.instance.collection('users').doc(user.userId).update({
      'email': user.email,
      'phoneNumber': user.phoneNumber,
      'username': user.userName,
      'downloadurl': _userList[userIndex].downloadurl,
    }).then((value) {
      notifyListeners();
    });
  }

  // טענת כניסה: אין
  // טענת יציאה: הפעולה מחזירה עותק של רשימת המשתמשים המקומית
  List<User> get users {
    return [..._userList];
  }

  // טענת כניסה: הפעולה מקבלת מזהה של משתמש
  // טענת יציאה: הפעולה מחזיר עצם מסוג משתמש המכיל את פרטי המשתמש
  User getUserData(String userId) {
    final userIndex = _userList.indexWhere((element) {
      return userId == element.userId;
    });
    return _userList[userIndex];
  }
}
