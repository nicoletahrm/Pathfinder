import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pathfinder_app/models/difficulty.dart';
import '../utils/covert.dart';

class Trail {
  final String? id;
  final String title;
  final String content;
  final String coverImage;
  final double rating;
  final double distance;
  final Difficulty difficulty;
  final double altitude;
  final GeoPoint destination;
  final List<dynamic> images;
  final List<dynamic> routes;

  Trail({
    required this.id,
    required this.rating,
    required this.title,
    required this.content,
    required this.coverImage,
    required this.distance,
    required this.difficulty,
    required this.altitude,
    required this.destination,
    required this.images,
    required this.routes,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "content": content,
      "coverImage": coverImage,
      "distance": distance,
      "difficulty": difficulty,
      "altitude": altitude,
      "rating": rating,
      "destination": destination,
      "images": images,
      "routes": routes,
    };
  }

  factory Trail.fromJson(Map<String, dynamic> json) {
    final data = json;

    return Trail(
      id: data["id"],
      title: data["title"],
      content: data["content"],
      coverImage: data["coverImage"],
      distance: stringToDouble(data["distance"]),
      difficulty: stringToDifficulty(data["difficulty"]),
      altitude: stringToDouble(data["altitude"]),
      rating: stringToDouble(data["rating"]),
      destination: data["destination"],
      images: List<String>.from(data['images'] ?? []),
      routes: List<String>.from(data['routes'] ?? []),
    );
  }
}
