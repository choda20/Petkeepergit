import 'package:flutter/cupertino.dart';

class Post {
  final String userId;
  final String userEmail;
  final Image postImage;
  final String title;
  final String description;
  final int salary;
  final int numberOfPets;
  final int walks;
  final int feeding;
  final int watering;

  Post({
    required this.userId,
    required this.userEmail,
    required this.postImage,
    required this.title,
    required this.description,
    required this.salary,
    required this.numberOfPets,
    required this.walks,
    required this.feeding,
    required this.watering,
  });
}
