import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pathfinder_app/utils/constant_colors.dart';

class StarReviewWidget extends StatefulWidget {
  final void Function(double rating) onRatingNeeded;

  const StarReviewWidget({
    Key? key,
    required this.onRatingNeeded,
  }) : super(key: key);

  @override
  _StarReviewWidgetState createState() => _StarReviewWidgetState();
}

class _StarReviewWidgetState extends State<StarReviewWidget> {
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return RatingBar(
      initialRating: _rating,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      ratingWidget: RatingWidget(
        full: const Icon(Icons.star, color: kRatingColor),
        half: const Icon(Icons.star_half, color: kRatingColor),
        empty: const Icon(Icons.star_border, color: kRatingColor),
      ),
      onRatingUpdate: (rating) {
        setState(() {
          _rating = rating;
          widget.onRatingNeeded(rating);
        });
      },
    );
  }
}
