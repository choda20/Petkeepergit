import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:provider/provider.dart';

import '../models/post.dart';
import '../models/rating.dart';
import '../providers/user_provider.dart';
import '../widgets/gradient_icons.dart';
import '../widgets/show_rating.dart';

class RatingItem extends StatelessWidget {
  Rating rating;
  Post postData;
  RatingItem(this.rating, this.postData);

  @override
  Widget build(BuildContext context) {
    final rater =
        Provider.of<UserProvider>(context).getUserData(rating.ratedBy);
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: GradientText(
                    "${rater.userName}'s rating",
                    colors: const [Color(0xfffe5858), Color(0xffee9617)],
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  content: ShowRating(rating),
                ));
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(8)),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: GradientText(
                        postData.title,
                        colors: const [Color(0xfffe5858), Color(0xffee9617)],
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    Text(
                      'rated by ${rater.userName}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  GradientText(
                    '${rating.stars}/5',
                    colors: const [Color(0xfffe5858), Color(0xffee9617)],
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  RadiantGradientMask(
                    child: const Icon(
                      Icons.star,
                      size: 25,
                      color: Colors.white,
                    ),
                  )
                ]),
              ]),
        ),
      ),
    );
  }
}
