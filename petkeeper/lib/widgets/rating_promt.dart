import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/gradient_button.dart';
import '../providers/rating_provider.dart';
import '../models/rating.dart';
import '../providers/request_provider.dart';
import '../widgets/gradient_icons.dart';

class RatingPromt extends StatefulWidget {
  String postId;
  bool isFromWorker;
  bool isEditing;
  String uid;
  RatingPromt(this.postId, this.isFromWorker, this.isEditing, this.uid);
  @override
  State<RatingPromt> createState() => _RatingPromtState();
}

class _RatingPromtState extends State<RatingPromt> {
  TextEditingController _descriptionController = TextEditingController();
  String _description = '';
  int _stars = 1;
  Rating ratingData = Rating('', 0, '', '', '', '', '');
  bool firstTime = true;
  String? get _error {
    final text = _descriptionController.text;
    if (text == '') {
      return 'Enter a description of your score';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final ratingsProvider = Provider.of<RatingProvider>(context);
    final requestsProvider = Provider.of<RequestProvider>(context);
    final postRequest =
        requestsProvider.getAcceptedRequestByPostId(widget.postId);
    if (widget.isEditing && firstTime == true) {
      ratingData = ratingsProvider.getRating(widget.postId, widget.uid);
      _stars = ratingData.stars;
      _description = ratingData.description;
      _descriptionController.text = ratingData.description;
      firstTime = false;
    }

    return SingleChildScrollView(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text(
            'Overall rating',
            style: TextStyle(fontSize: 18),
          ),
          Row(
            children: [
              DropdownButton<int>(
                  value: _stars,
                  items:
                      [1, 2, 3, 4, 5].map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                        value: value,
                        child: Text(
                          value.toString(),
                          style: const TextStyle(fontSize: 18),
                        ));
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      _stars = newValue!;
                    });
                  }),
              RadiantGradientMask(
                child: const Icon(
                  Icons.star,
                  size: 25,
                  color: Colors.white,
                ),
              ),
            ],
          )
        ]),
        TextField(
          decoration: InputDecoration(errorText: _error),
          style: const TextStyle(fontSize: 18),
          controller: _descriptionController,
          onChanged: (text) {
            setState(() {
              _description = text;
            });
          },
          maxLines: null,
        ),
        const SizedBox(height: 20),
        GradientButton(() {
          if (_error == null) {
            widget.isEditing == false
                ? ratingsProvider.addRating(Rating(
                    _description,
                    _stars,
                    postRequest.posterId,
                    postRequest.requesterId,
                    widget.isFromWorker
                        ? postRequest.requesterId
                        : postRequest.posterId,
                    '',
                    widget.postId))
                : ratingsProvider.updateRating(Rating(
                    _description,
                    _stars,
                    ratingData.poster,
                    ratingData.careTaker,
                    ratingData.ratedBy,
                    ratingData.ratingId,
                    ratingData.postId));
            Navigator.of(context).pop();
          }
        }, 40, 90, Icons.done, 'Publish', 15)
      ]),
    );
  }
}
