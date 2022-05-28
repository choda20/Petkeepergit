import '../../models/post.dart';

class PostScreenArgs {
  final Post postData;
  final bool isEditing;
  final bool isFromProfileScreen;
  final bool isAccepted;
  PostScreenArgs(
      this.postData, this.isEditing, this.isFromProfileScreen, this.isAccepted);
}
