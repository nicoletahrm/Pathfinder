import 'package:firebase_auth/firebase_auth.dart';

class Review {
  final int id;
  final User user;
  final String title;
  final String review;
  final List<String> images;
  final double rating;
  final Duration time;

  Review({
    required this.id,
    required this.user,
    required this.images,
    required this.rating,
    required this.title,
    required this.review,
    required this.time,
  });
}
