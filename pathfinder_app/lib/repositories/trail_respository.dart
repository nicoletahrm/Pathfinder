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
        .map((docSnapshot) => Trail.fromJson(docSnapshot.data()))
        .toList();
  }

  Future<Trail?> getTrailByTitle(String trailTitle) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await database
        .collection("trail")
        .where('title', isEqualTo: trailTitle)
        .get();

    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          snapshot.docs[0];

      print(documentSnapshot.id);

      Map<String, dynamic>? data = documentSnapshot.data();
      return Trail.fromJson(data!);
    } else {
      return null;
    }
  }

  Future<DocumentReference> getRefTrailByTitle(String trailTitle) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await database
        .collection("trail")
        .where('title', isEqualTo: trailTitle)
        .get();

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = snapshot.docs[0];

    return documentSnapshot.reference;
  }

  // Future<List<Review>> getAllReviews() async {
  //   QuerySnapshot<Map<String, dynamic>> snapshot =
  //       await database.collection("review").get();

  //   return snapshot.docs
  //       .map((docSnapshot) => Review.fromJson(docSnapshot))
  //       .toList();
  // }

  Future<List<Review>> getTrailReviewsByRef(DocumentReference ref) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('review')
        .where('trail', isEqualTo: ref)
        .get();

    List<Review> reviews = [];
    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
        in snapshot.docs) {
      Map<String, dynamic> data = documentSnapshot.data();
      Review review = Review.fromJson(data);
      reviews.add(review);
    }

    return reviews;
  }

  Future<User?> getUserByRef(DocumentReference<Object?>? ref) async {
    if (ref == null) {
      return null;
    }

    final userSnapshot = await ref.get();

    if (userSnapshot.exists) {
      final userData = userSnapshot.data() as Map<String, dynamic>;
      return User.fromJson(userData);
    }

    return null;
  }

  Future<Trail?> getTrailByRef(DocumentReference<Object?>? ref) async {
    if (ref == null) {
      return null;
    }

    final trailSnapshot = await ref.get();

    if (trailSnapshot.exists) {
      final trailData = trailSnapshot.data() as Map<String, dynamic>;
      return Trail.fromJson(trailData);
    }

    return null;
  }
}
