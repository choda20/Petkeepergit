import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Post {
  final String userId;
  final String dates;
  final String postImage;
  final String title;
  final String description;
  final int salary;
  final int walks;
  final int feeding;
  final int watering;

  Post({
    required this.userId,
    required this.dates,
    required this.postImage,
    required this.title,
    required this.description,
    required this.salary,
    required this.walks,
    required this.feeding,
    required this.watering,
  });

  Future<String> get imageUrl async {
    final _firebaseStorage =
        FirebaseStorage.instance.ref().child('images/$postImage+$title');
    final imageUrl = await _firebaseStorage.getDownloadURL();
    return imageUrl.toString();
  }
}
