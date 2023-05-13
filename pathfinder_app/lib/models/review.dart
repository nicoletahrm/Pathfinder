import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/covert_to.dart';

class Review {
  final User user;
  final String title;
  final String content;
  final double rating;
  final Duration time;
  final List<dynamic> images;

  Review({
    required this.user,
    required this.title,
    required this.content,
    required this.rating,
    required this.time,
    required this.images,
  });

  factory Review.fromJson(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    final data = json.data();

    return Review(
      user: data["user"],
      title: data["title"],
      content: data["content"],
      rating: stringToDouble(data["rating"]),
      time: data["time"],
      images: List<String>.from(data['images'] ?? []),
    );
  }
}
