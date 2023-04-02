import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pathfinder_app/models/difficulty.dart';
import 'package:pathfinder_app/models/review_model.dart';

class Trail {
  final String title;
  final String description;
  final String coverImage;
  //final List<String>? images;
  final double rating;
  //final Duration time;
  //final double routeLength;
  final Difficulty difficulty;
  //final List<Review>? reviews;
  //final int altitude;
  //marcaj traseu

  Trail({
    //this.images,
    this.rating = 0.0,
    required this.title,
    required this.description,
    required this.coverImage,
    // required this.time,
    //required this.routeLength,
    required this.difficulty,
    //required this.altitude,
    //this.reviews,
  });

  // for insert into database
  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "description": description,
      "coverImage": coverImage,
      //"time": time,
      //"routeLength": routeLength,
      "difficulty": difficulty,
      //"altitude": altitude,
      //"reviews": reviews,
      "rating": rating,
      //"images": images,
    };
  }

  // for read from database
  factory Trail.fromMap(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    return Trail(
      title: json["title"],
      description: json["description"],
      coverImage: json["coverImage"],
      //time: json["time"],
      //routeLength: json["routeLength"],
      difficulty: difficultyFromString(json["difficulty"]),
      //altitude: json["altitude"],
      //reviews: json["reviews"],
      rating: ratingFromString(json["rating"]),
      //images: json["images"],
    );
  }
}

double ratingFromString(String value) {
  return double.parse(value);
}
