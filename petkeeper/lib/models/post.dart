class Post {
  final String postImage;
  final String title;
  final String description;
  final int salary;
  final int numberOfPets;
  final int walks;
  final int feeding;
  final int water;
  var adress;

  Post({
    required this.postImage,
    required this.title,
    required this.description,
    required this.salary,
    required this.numberOfPets,
    required this.walks,
    required this.feeding,
    required this.water,
    this.adress,
  });
}
