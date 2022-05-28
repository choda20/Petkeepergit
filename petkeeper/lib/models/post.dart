class Post {
  final String userId;
  String postId;
  String startingDate;
  String endingDate;
  String title;
  String downloadUrl;
  String description;
  int salary;
  int walks;
  int feeding;
  int watering;
  int petNum;

  Post({
    required this.userId,
    required this.downloadUrl,
    required this.startingDate,
    required this.endingDate,
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
