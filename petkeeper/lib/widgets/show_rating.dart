import 'package:flutter/material.dart';

import '../models/rating.dart';
import '../widgets/gradient_icons.dart';

class ShowRating extends StatelessWidget {
  Rating rating;
  ShowRating(this.rating);
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
          )
        ]);
  }
}
