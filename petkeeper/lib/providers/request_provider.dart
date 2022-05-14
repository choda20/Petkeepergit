import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/request.dart';

class RequestProvider with ChangeNotifier {
  List<Request> _requests = [];

  Future<void> fetchRequests() async {
    _requests = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('requests').get();
    for (var doc in querySnapshot.docs) {
      Request newRequest = Request(doc['postid'], doc['posterid'],
          doc['requesterid'], doc['status'], doc.id);
      _requests.add(newRequest);
    }
  }

  List<Request> get requests {
    return [..._requests];
  }

  bool hasRequested(String requesterId, String posterid, String postid) {
    final check = _requests.where((element) =>
        element.postId == postid &&
        element.posterId == posterid &&
        element.requesterId == requesterId);

    if (check.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> addRequest(Request newRequest) async {
    late String requestId;
    final docPath = FirebaseFirestore.instance.collection('requests').doc();
    await docPath.set({
      'requesterid': newRequest.requesterId,
      'status': newRequest.status,
      'postid': newRequest.postId,
      'posterid': newRequest.posterId
    }).then((value) {
      requestId = docPath.id;
    });
    newRequest.requestId = requestId;
    _requests.add(newRequest);
    notifyListeners();
  }
}
