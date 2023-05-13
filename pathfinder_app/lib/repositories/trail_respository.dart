import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review.dart';
import '../models/trail.dart';

class TrailRepository {
  final FirebaseFirestore database = FirebaseFirestore.instance;

  Future<List<Trail>> getAllTrails() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await database.collection("trail").orderBy('title').get();

    return snapshot.docs
        .map((docSnapshot) => Trail.fromJson(docSnapshot))
        .toList();
  }

  Future<List<Review>> getAllReviews() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await database.collection("review").get();

    print(snapshot.docs
        .map((docSnapshot) => Review.fromJson(docSnapshot))
        .toList());

    return snapshot.docs
        .map((docSnapshot) => Review.fromJson(docSnapshot))
        .toList();
  }
}
