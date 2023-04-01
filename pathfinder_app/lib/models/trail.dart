import 'package:pathfinder_app/models/difficulty.dart';
import 'package:pathfinder_app/models/review_model.dart';

class Trail {
  final int id;
  final String title;
  final String description;
  final String coverImage;
  final List<String>? images;
  final double rating;
  final Duration time;
  final double routeLength;
  final Difficulty difficulty;
  final List<Review>? reviews;
  final int altitude;
  //marcaj traseu

  Trail({
    required this.id,
    this.images,
    this.rating = 0.0,
    required this.title,
    required this.description,
    required this.coverImage,
    required this.time,
    required this.routeLength,
    required this.difficulty,
    required this.altitude,
    this.reviews, required,
  });

  Map<String,dynamic> toMap(){
  return {
    "title": title,
    "description": description,
    "coverImage": coverImage,
    "time": time,
    "routeLength": routeLength,
    "difficulty": difficulty,
    "altitude": altitude,
    "reviews": reviews,
    "rating": rating,
    "images": images,
  };
}
}
