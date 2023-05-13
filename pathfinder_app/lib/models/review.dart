import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/covert_to.dart';

class Review {
  final String title;
  final String content;
  final double rating;
  final double time;
  final List<dynamic> images;

  Review({
    required this.rating,
    required this.title,
    required this.content,
    required this.time,
    required this.images,
  });

  factory Review.fromJson(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    final data = json.data();

    return Review(
      time: stringToDouble(data["time"]),
      title: data["title"],
      content: data["content"],
      rating: stringToDouble(data["rating"]),
      images: List<String>.from(data['images'] ?? []),
    );
  }
}
