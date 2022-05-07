import '../../models/post.dart';

class PostScreenArgs {
  final Post postData;
  final bool isEditing;
  PostScreenArgs(this.postData, this.isEditing);
}
