import 'package:flutter/cupertino.dart';

class Post {
  final Image postImage;
  final String title;
  final String description;
  final int salary;
  final int numberOfPets;
  final int walks;
  final int feeding;
  final int watering;
  var address;

  Post({
    required this.postImage,
    required this.title,
    required this.description,
    required this.salary,
    required this.numberOfPets,
    required this.walks,
    required this.feeding,
    required this.watering,
    this.address,
  });
}
