import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../models/post.dart';
import '../widgets/gradient_icons.dart';
import '../widgets/post_item.dart';
import '../widgets/rating_promt.dart';
import '../providers/rating_provider.dart';
import '../providers/auth_provider.dart';

class PastJobsItem extends StatelessWidget {
  Post postData;
  PastJobsItem(this.postData);
  @override
  Widget build(BuildContext context) {
    final ratingProvider = Provider.of<RatingProvider>(context);
    final uid = Provider.of<AuthProvider>(context).user.uid;
    return Row(
      children: [
        Expanded(
          child: PostItem(postData, false, false, false),
          flex: 7,
        ),
        ratingProvider.careTakerHasRated(uid, postData.postId) == false
            ? IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: GradientText(
                              "Leave a rating",
                              colors: const [
                                Color(0xfffe5858),
                                Color(0xffee9617)
                              ],
                              style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            content:
                                RatingPromt(postData.postId, true, false, uid),
                          ));
                },
                icon: RadiantGradientMask(
                    child:
                        const Icon(Icons.star, color: Colors.white, size: 35)))
            : IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: GradientText(
                              "Edit rating",
                              colors: const [
                                Color(0xfffe5858),
                                Color(0xffee9617)
                              ],
                              style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            content:
                                RatingPromt(postData.postId, true, true, uid),
                          ));
                },
                icon: RadiantGradientMask(
                    child:
                        const Icon(Icons.star, color: Colors.white, size: 35))),
      ],
    );
  }
}
