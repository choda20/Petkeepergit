class Post {
  final String userId;
  final String postId;
  String dates;
  String title;
  String description;
  int salary;
  int walks;
  int feeding;
  int watering;
  int petNum;

  Post({
    required this.userId,
    required this.dates,
    required this.title,
    required this.description,
    required this.salary,
    required this.walks,
    required this.feeding,
    required this.watering,
    required this.petNum,
    required this.postId,
  });
}
