import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/covert.dart';

class Review {
  final String content;
  final double rating;
  final DocumentReference<Object?>? user;
  final List<dynamic> images;

  Review({
    required this.content,
    required this.rating,
    required this.user,
    required this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      "content": content,
      "rating": rating,
      "user": user,
      "images": images,
    };
  }

  factory Review.fromJson(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    final data = json.data();

    return Review(
      content: data["content"],
      user: data["user"],
      rating: stringToDouble(data["rating"]),
      images: List<String>.from(data['images'] ?? []),
    );
  }
}
