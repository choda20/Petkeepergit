import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:petkeeper/models/user.dart';

class UserProvider with ChangeNotifier {
  List<User> _userList = [];

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

  List<User> get users {
    return [..._userList];
  }

  User getUserData(String userId) {
    final userIndex = _userList.indexWhere((element) {
      return userId == element.userId;
    });
    return _userList[userIndex];
  }
}
