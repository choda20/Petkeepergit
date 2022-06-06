import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../models/post.dart';
import '../screens/screen_args/post_screen_args.dart';
import '../models/rating.dart';
import '../widgets/gradient_icons.dart';

class ShowRating extends StatelessWidget {
  Rating rating;
  Post postData;
  ShowRating(this.rating, this.postData);

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text(
              'Overall rating',
              style: TextStyle(fontSize: 18),
            ),
            Row(children: [
              Text('${rating.stars}', style: const TextStyle(fontSize: 18)),
              RadiantGradientMask(
                child: const Icon(
                  Icons.star,
                  size: 25,
                  color: Colors.white,
                ),
              ),
            ])
          ]),
          const SizedBox(height: 20),
          const Text(
            'Full review:',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            child:
                Text(rating.description, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/post-screen',
                  arguments: PostScreenArgs(postData, false, true, false));
            },
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              RadiantGradientMask(
                child: const Icon(
                  Icons.feed_outlined,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              GradientText('To post',
                  colors: const [Color(0xfffe5858), Color(0xffee9617)],
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black))
            ]),
          )
        ]);
  }
}
