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
  final GeoPoint start;
  final GeoPoint end;
  final List<dynamic> images;
  //final List<dynamic> path;

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
    required this.start,
    required this.end,
    required this.images,
    //required this.path,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "content": content,
      "coverImage": coverImage,
      "distance": distance,
      "difficulty": difficulty,
      "altitude": altitude,
      "rating": rating,
      "start": start,
      "end": end,
      "images": images,
      //"path": path,
    };
  }

  factory Trail.fromJson(Map<String, dynamic> json) {
    final data = json;

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
      start: data["start"],
      end: data["end"],
      images: List<String>.from(data['images'] ?? []),
      //path: List<GeoPoint>.from(data['path'] ?? []),
    );
  }
}
