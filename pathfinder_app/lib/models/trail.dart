import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pathfinder_app/models/difficulty.dart';
import '../utils/covert.dart';

class Trail {
  final String? id;
  final String title;
  final String description;
  final String content;
  final String coverImage;
  final double rating;
  final double distance;
  final Difficulty difficulty;
  final double altitude;
  final double latitude;
  final double longitude;
  final List<dynamic> images;

  Trail({
    required this.id,
    required this.rating,
    required this.title,
    required this.description,
    required this.content,
    required this.coverImage,
    required this.distance,
    required this.difficulty,
    required this.altitude,
    required this.latitude,
    required this.longitude,
    required this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      //"id": id,
      "title": title,
      "description": description,
      "content": content,
      "coverImage": coverImage,
      "distance": distance,
      "difficulty": difficulty,
      "altitude": altitude,
      "rating": rating,
      "latitude": latitude,
      "longitude": longitude,
      "images": images,
    };
  }

  factory Trail.fromJson(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    final data = json.data();

    return Trail(
      id: data["id"],
      title: data["title"],
      description: data["description"],
      content: data["content"],
      coverImage: data["coverImage"],
      distance: stringToDouble(data["distance"]),
      difficulty: stringToDifficulty(data["difficulty"]),
      altitude: stringToDouble(data["altitude"]),
      rating: stringToDouble(data["rating"]),
      latitude: stringToDouble(data["latitude"]),
      longitude: stringToDouble(data["longitude"]),
      images: List<String>.from(data['images'] ?? []),
    );
  }
}
