import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/request.dart';
import '../models/post.dart';

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

  Request getAcceptedRequestByPostId(String postId) {
    Request wantedRequest = _requests.firstWhere(
        (element) => element.postId == postId && element.status == true);
    return wantedRequest;
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

  void addRequest(Request newRequest) {
    late String requestId;
    final docPath = FirebaseFirestore.instance.collection('requests');
    docPath.add({
      'requesterid': newRequest.requesterId,
      'status': newRequest.status,
      'postid': newRequest.postId,
      'posterid': newRequest.posterId
    }).then((value) {
      requestId = docPath.id;
      newRequest.requestId = requestId;
      _requests.add(newRequest);
      notifyListeners();
    });
  }

  List<Post> getPendingPosts(List<Post> postList) {
    List<Post> newList = [...postList];
    for (var request in _requests) {
      for (var post in postList) {
        if (request.postId == post.postId && request.status == true) {
          newList.remove(post);
        }
      }
    }
    postList = newList;
    return postList;
  }

  String getCareTakerId(String postId) {
    final request = _requests.firstWhere(
        (element) => element.postId == postId && element.status == true);
    final careTakerId = request.requesterId;
    return careTakerId;
  }

  List<Request> getPendingRequests(String userId) {
    List<Request> pending = _requests
        .where((element) =>
            element.requesterId == userId && element.status == false)
        .toList();
    return pending;
  }

  List<String> getPendingRequestsPostIds(String userId) {
    List<String> postId = [];
    List<Request> pending = _requests
        .where((element) =>
            element.requesterId == userId && element.status == false)
        .toList();
    for (var request in pending) {
      if (!postId.contains(request.postId)) {
        postId.add(request.postId);
      }
    }
    return postId;
  }

  List<Request> getAcceptedRequests(String userId) {
    List<Request> accepted = _requests
        .where((element) =>
            element.requesterId == userId && element.status == true)
        .toList();
    return accepted;
  }

  List<String> getAcceptedRequestsPostIds(String userId) {
    List<String> postIds = [];
    List<Request> accepted = _requests
        .where((element) =>
            element.requesterId == userId && element.status == true)
        .toList();
    for (var element in accepted) {
      postIds.add(element.postId);
    }
    return postIds;
  }

  List<String> getPendingApplicationsPostIds(String userId) {
    List<String> postId = [];
    List<Request> pending = _requests
        .where(
            (element) => element.posterId == userId && element.status == false)
        .toList();
    for (var request in pending) {
      postId.add(request.postId);
    }
    return postId;
  }

  List<Request> getPendingApplications(String userId) {
    List<Request> pending = _requests
        .where(
            (element) => element.posterId == userId && element.status == false)
        .toList();
    return pending;
  }

  List<Request> getAcceptedApplications(String userId) {
    List<Request> accepted = _requests
        .where(
            (element) => element.posterId == userId && element.status == true)
        .toList();
    return accepted;
  }

  List<String> getAcceptedApplicationsPostIds(String userId) {
    List<String> postId = [];
    List<Request> pending = _requests
        .where(
            (element) => element.posterId == userId && element.status == true)
        .toList();
    for (var request in pending) {
      postId.add(request.postId);
    }
    return postId;
  }

  void deleteRequest(String requestId) {
    final requestIndex =
        _requests.indexWhere((element) => element.requestId == requestId);
    FirebaseFirestore.instance
        .collection('requests')
        .doc(_requests[requestIndex].requestId)
        .delete()
        .then((value) {
      _requests.removeAt(requestIndex);
      notifyListeners();
    });
  }

  void acceptRequest(String requestId, String postId) {
    List<Request> pastRequests = _requests
        .where((element) =>
            element.requestId != requestId && element.postId == postId)
        .toList();
    final requestIndex =
        _requests.indexWhere((element) => element.requestId == requestId);
    FirebaseFirestore.instance
        .collection('requests')
        .doc(_requests[requestIndex].requestId)
        .update({'status': true}).then((value) {
      _requests[requestIndex].status == true;
      for (var outDatedRequests in pastRequests) {
        FirebaseFirestore.instance
            .collection('requests')
            .doc(outDatedRequests.requestId)
            .delete()
            .then((value) {
          _requests.remove(outDatedRequests);
        });
        notifyListeners();
      }
    });
  }
}
