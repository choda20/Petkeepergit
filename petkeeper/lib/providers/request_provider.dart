import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/request.dart';
import '../models/post.dart';

class RequestProvider with ChangeNotifier {
  List<Request> _requests = [];

  // טענת כניסה: אין
  // _requests :טענת יציאה: הפעולה שולפת את הנתונים המאוחסנים בקולקציית הפוסטים ומאחסנת אותם ברשימת הפוסטים של מחלקה זו
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

  // טענת כניסה: הפעולה מקבלת מזהה של פוסט
  // טענת יציאה: הפעולה מחזירה את הבקשה המאושרת של פוסט זה
  // הערה: לכל פוסט יש בקשה מאושרת אחת, זאת מכיוון שבקשה מאושרת מסמלת שנמצא מטפל לפוסט והיא מכילה את המידע שלו
  Request getAcceptedRequestByPostId(String postId) {
    Request wantedRequest = _requests.firstWhere(
        (element) => element.postId == postId && element.status == true);
    return wantedRequest;
  }

  // טענת כניסה: אין
  // טענת יציאה: הפעולה מחזירה עותק של רשימת הבקשות המקומית
  List<Request> get requests {
    return [..._requests];
  }

  // טענת כניסה: הפעולה מקבלת מזהה של מבקש הבקשה, מפרסם הבקשה והפוסט שלגביו נשלחה הבקשה
  // טענת יציאה: הפעולה מחזירת "אמת" אם המשתמש שסופק המזהה שלו שלח בקשה לטפל בפוסט שהמזהה שלו סופק
  // "אם המשתמש לא שלח בקשה לטפל בפוסט הפעולה תחזיר "שקר
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

  // טענת כניסה: הפעולה מקבלת משתנה מסוג בקשה המכיל בקשה חדשה
  // טענת יציאה: הפעולה מוסיפה את הבקשה החדשה לקולקציית הבקשות במסד הנתונים
  // לאחר מכן מוסיפה הפעולה את הבקשה לרשימה המקומית ומתריעה על כך למאזינים
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

  // טענת כניסה: הפעולה מקבלת רשימה של פוסטים
  // טענת יציאה: הפעולה מחזירה רשימת פוסטים שטרם אושרה בקשה לטפל בהם
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

  // טענת כניסה: הפעולה מקבלת מזהה של פוסט
  // טענת יציאה: הפעולה מחזירה את המזהה של המטפל בפוסט
  String getCareTakerId(String postId) {
    final request = _requests.firstWhere(
        (element) => element.postId == postId && element.status == true);
    final careTakerId = request.requesterId;
    return careTakerId;
  }

  // טענת כניסה:הפעולה מקבלת מזהה של משתמש
  // טענת יציאה: הפעולה מחזירה רשימה של בקשות המשתמש שטרם אושרו
  List<Request> getPendingRequests(String userId) {
    List<Request> pending = _requests
        .where((element) =>
            element.requesterId == userId && element.status == false)
        .toList();
    return pending;
  }

  // טענת כניסה: הפעולה מקבלת מזהה של משתמש
  // טענת יציאה: הפעולה מחזירה רשימה של מזההי הפוסטים שטרם אושרה בקשת השמתמש לטפל בהם
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

  // טענת כניסה: הפעולה מקבלת מזהה של משתמש
  // טענת יציאה: הפעולה מחזירה רשימה של בקשות המשתמש שאושרו
  List<Request> getAcceptedRequests(String userId) {
    List<Request> accepted = _requests
        .where((element) =>
            element.requesterId == userId && element.status == true)
        .toList();
    return accepted;
  }

  // טענת כניסה: הפעולה מקבלת מזהה של משתמש
  // טענת יציאה: הפעולה מחזירה רשימה של מזההי הפוסטים שבקשת המשתמש לטפל בהם אושרה
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

  // טענת כניסה: הפעולה מקבלת מזהה של משתמש
  // טענת יציאה: הפעולה מחזירה רשימה של מזההי הפוסטים שלא אישר להם המשתמש בקשה לטיפול (לא נמצא להם מטפל)
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

  // טענת כניסה: הפעולה מקבלת מזהה של משתמש
  // טענת יציאה: הפעולה מחזירה רשימה של בקשות שלא אישר להן המשתמש בקשה לטיפול (לא נמצא להם מטפל)
  List<Request> getPendingApplications(String userId) {
    List<Request> pending = _requests
        .where(
            (element) => element.posterId == userId && element.status == false)
        .toList();
    return pending;
  }

  // טענת כניסה: הפעולה מקבלת מזהה של משתמש
  //  טענת יציאה: הפעולה מחזירה רשימה של בקשות אשר אישר להן המשתמש בקשה לטיפול
  List<Request> getAcceptedApplications(String userId) {
    List<Request> accepted = _requests
        .where(
            (element) => element.posterId == userId && element.status == true)
        .toList();
    return accepted;
  }

  // טענת כניסה: הפעולה מקבלת מזהה של משתמש
  // טענת יציאה: הפעולה מחזירה רשימה של מזההי הפוסטים אשר אישר להם המשתמש בקשה לטיפול
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

  // טענת כניסה: הפעולה מקבלת רשימה של מזההי פוסטים אשר עבר תאריך הסיום שלהם
  // ,טענת יציאה: הפעולה מוחקת מקולקציית הבקשות בקשות לא מאושרות לטפל בפוסטים ברשימה שסופקה
  // מדובר בבקשות שלא רלוונטיות היות והפוסטים שהן מתייחסות אליהם לא רלוונטים יותר
  // הערה: הפעולה לא מודיע למאזינים שהתרחש שינוי ברשימה מכיוון והיא מופעלת כאשר מסך הבית נטען ואין צורך לעדכן את ממשק המשתמש
  Future<void> deleteExpiredRequests(List<String> postIds) async {
    List<Request> pastRequests = [];
    for (var postId in postIds) {
      pastRequests =
          _requests.where((element) => element.postId == postId).toList();
      for (var outDatedRequests in pastRequests) {
        if (outDatedRequests.status != true) {
          await FirebaseFirestore.instance
              .collection('requests')
              .doc(outDatedRequests.requestId)
              .delete()
              .then((value) {
            _requests.remove(outDatedRequests);
          });
        }
      }
    }
  }

  // טענת כניסה: הפעולה מקבלת מזהה של בקשה
  // טענת יציאה: הפעולה מוחקת את הבקשה ממסד הנתונים ומהרשימה המקומית ומתריעה על כך למאזינים
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

  // טענת כניסה: הפעולה מקבלת מזהה של בקשה ומזהה של רשימה
  // טענת יציאה: הפעולה מאשרת את הבקשה במסד הנתונים וברשימה המקומית ומוחקת את שאר הבקשות
  // אשר נשלחו לגבי הפוסט המסופק ולאחר מכן מתריעה למאזינים על כך
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
      }
      _requests[requestIndex].status = true;
      notifyListeners();
    });
  }
}
