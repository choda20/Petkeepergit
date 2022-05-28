import 'package:flutter/material.dart';
import 'package:petkeeper/providers/rating_provider.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../providers/auth_provider.dart';
import '../widgets/rating_promt.dart';
import '../providers/user_provider.dart';
import '../widgets/post_item.dart';
import '../widgets/gradient_icons.dart';
import '../providers/request_provider.dart';
import '../models/post.dart';
import '../screens/screen_args/profile_screen_args.dart';
import '../models/request.dart';

class RequestItem extends StatelessWidget {
  Request requestData;
  Post postData;
  bool isHired;
  bool isAccepted;
  RequestItem(this.postData, this.requestData, this.isHired, this.isAccepted);

  @override
  Widget build(BuildContext context) {
    final userData =
        Provider.of<UserProvider>(context).getUserData(requestData.requesterId);
    final currentUID = Provider.of<AuthProvider>(context).user.uid;
    final ratingProvider = Provider.of<RatingProvider>(context);
    if (isHired) {
      return Row(
        children: [
          Expanded(flex: 7, child: PostItem(postData, true, false, isAccepted)),
          Column(children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/profile-screen',
                      arguments: ProfileScreenArgs(requestData.requesterId));
                },
                icon: RadiantGradientMask(
                    child: const Icon(Icons.person,
                        color: Colors.white, size: 35))),
            const SizedBox(
              height: 10,
            ),
            IconButton(
                onPressed: () {
                  ratingProvider.posterHasRated(currentUID, postData.postId) ==
                          true
                      ? showDialog(
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
                                content: RatingPromt(
                                    postData.postId, false, true, currentUID),
                              ))
                      : showDialog(
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
                                content: RatingPromt(
                                    postData.postId, false, false, currentUID),
                              ));
                },
                icon: RadiantGradientMask(
                    child:
                        const Icon(Icons.star, color: Colors.white, size: 35)))
          ]),
        ],
      );
    } else {
      return Row(children: [
        Expanded(
          child: PostItem(postData, true, false, isAccepted),
          flex: 7,
        ),
        Column(children: [
          IconButton(
              onPressed: () {
                Provider.of<RequestProvider>(context, listen: false)
                    .acceptRequest(requestData.requestId, postData.postId);
              },
              icon: RadiantGradientMask(
                  child:
                      const Icon(Icons.done, color: Colors.white, size: 30))),
          IconButton(
              onPressed: () {
                Provider.of<RequestProvider>(context, listen: false)
                    .deleteRequest(requestData.requestId);
              },
              icon: RadiantGradientMask(
                  child:
                      const Icon(Icons.delete, color: Colors.white, size: 30)))
        ])
      ]);
    }
  }
}
