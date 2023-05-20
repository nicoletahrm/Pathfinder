import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review.dart';
import '../models/trail.dart';
import '../models/user.dart';

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

    // print(snapshot.docs
    //     .map((docSnapshot) => Review.fromJson(docSnapshot))
    //     .toList());

    return snapshot.docs
        .map((docSnapshot) => Review.fromJson(docSnapshot))
        .toList();
  }

  Future<User?> getUser(DocumentReference<Object?>? userRef) async {
    if (userRef == null) {
      return null;
    }

    final userSnapshot = await userRef.get();

    if (userSnapshot.exists) {
      final userData = userSnapshot.data() as Map<String, dynamic>;
      return User.fromJson(userData);
    }

    return null;
  }
}
