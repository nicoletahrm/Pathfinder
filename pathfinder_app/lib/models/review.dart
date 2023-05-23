import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/covert.dart';

class Review {
  final String content;
  final double rating;
  final DocumentReference<Object?>? user;
  final DocumentReference<Object?>? trail;
  final List<String> images;

  Review({
    required this.content,
    required this.rating,
    required this.user,
    required this.trail,
    required this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      "content": content,
      "rating": rating,
      "user": user,
      "trail": trail,
      "images": images,
    };
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    final data = json;

    return Review(
      content: data["content"],
      user: data["user"],
      trail: data["trail"],
      rating: stringToDouble(data["rating"]),
      images: List<String>.from(data['images'] ?? []),
    );
  }
}
