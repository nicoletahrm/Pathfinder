import '../utils/covert.dart';

class Review {
  final String id;
  final String content;
  final double rating;
  final String user;
  final String trail;
  final List<String> images;

  Review({
    required this.id,
    required this.content,
    required this.rating,
    required this.user,
    required this.trail,
    required this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
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
      id: data["id"],
      content: data["content"],
      user: data["user"],
      trail: data["trail"],
      rating: stringToDouble(data["rating"]),
      images: List<String>.from(data['images'] ?? []),
    );
  }
}
