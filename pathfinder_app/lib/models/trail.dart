import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pathfinder_app/models/difficulty.dart';

class Trail {
  final String title;
  final String description;
  final String coverImage;
  final double rating;
  final double distance;
  final Difficulty difficulty;
  final double altitude;
  final double latitude;
  final double longitude;
  //marcaj traseu

  Trail({
    required this.rating,
    required this.title,
    required this.description,
    required this.coverImage,
    required this.distance,
    required this.difficulty,
    required this.altitude,
    required this.latitude,
    required this.longitude,
  });

  // for insert into database
  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "description": description,
      "coverImage": coverImage,
      "distance": distance,
      "difficulty": difficulty,
      "altitude": altitude,
      "rating": rating,
      "latitude": latitude,
      "longitude": longitude,
    };
  }

  // for read from database
  factory Trail.fromMap(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    return Trail(
      title: json["title"],
      description: json["description"],
      coverImage: json["coverImage"],
      distance: stringToDouble(json["distance"]),
      difficulty: stringToDifficulty(json["difficulty"]),
      altitude: stringToDouble(json["altitude"]),
      rating: stringToDouble(json["rating"]),
      latitude: stringToDouble(json["latitude"]),
      longitude: stringToDouble(json["longitude"]),
    );
  }
}

double stringToDouble(String value) {
  return double.parse(value);
}

int stringToInt(String value) {
  return int.parse(value);
}
