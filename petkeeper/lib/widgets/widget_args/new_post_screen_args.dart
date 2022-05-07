import 'package:petkeeper/models/post.dart';

class NewPostScreenArgs {
  Post? postData;
  bool isEditing;
  NewPostScreenArgs(this.postData, this.isEditing);
}
