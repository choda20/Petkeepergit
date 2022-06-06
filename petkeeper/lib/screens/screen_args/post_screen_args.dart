import '../../models/post.dart';

class PostScreenArgs {
  final Post postData;
  final bool isEditing;
  final bool isRequestRelevant;
  final bool isAccepted;
  PostScreenArgs(
      this.postData, this.isEditing, this.isRequestRelevant, this.isAccepted);
}
