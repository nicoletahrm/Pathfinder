import 'package:pathfinder_app/models/difficulty.dart';
import 'package:pathfinder_app/models/review_model.dart';

class Route {
  final int id;
  final String title;
  final String description;
  final List<String> images;
  final double rating;
  final Duration time;
  final double routeLength;
  final Difficulty difficulty;
  final List<Review> reviews;

  Route({
    required this.id,
    required this.images,
    this.rating = 0.0,
    required this.title,
    required this.description,
    required this.time,
    required this.routeLength,
    required this.difficulty,
    required this.reviews,
  });
}
