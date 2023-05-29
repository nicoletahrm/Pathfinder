// ignore_for_file: unused_element

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/review.dart';
import '../models/trail.dart';
import 'dart:io';
import '../models/user.dart';
import '../utils/covert.dart';

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

  Future<User> getUserByRef(DocumentReference<Object?>? ref) async {
    final userSnapshot = await ref!.get();

    if (userSnapshot.exists) {
      final userData = userSnapshot.data() as Map<String, dynamic>;
      return User.fromJson(userData);
    }

    throw Exception(
        'User not found.'); // Throw an exception if the user does not exist
  }

  Future<DocumentReference> getUserRefByEmail(String? email) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await database
        .collection("user")
        .where('email', isEqualTo: email)
        .get();

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = snapshot.docs[0];

    return documentSnapshot.reference;
  }

  Future<List<String>?> getFavoriteTrails(String? email) async {
    final userDocRef = await getUserRefByEmail(email);
    final userDocSnapshot = await userDocRef.get();

    if (userDocSnapshot.exists) {
      final userData = userDocSnapshot.data() as Map<String, dynamic>;
      final user = User.fromJson(userData);

      return user.trails;
    }
    return null;
  }

  Future<void> updateFavoriteTrails(
      String? email, List<String> favoriteTrails) async {
    try {
      // Get the user's document reference
      final userDocRef = await getUserRefByEmail(email);
      final userDocSnapshot = await userDocRef.get();

      // Update the favoriteTrails field in the user's document
      await userDocRef.update({'trails': favoriteTrails});
    } catch (e) {
      // Handle any errors that occur during the update process
      print('Error updating favorite trails: $e');
    }
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

  void addReview(String content, List<String> images, String rating,
      DocumentReference<Object?>? ref, DocumentReference<Object?>? user) async {
    try {
      CollectionReference collectionRef = database.collection('review');

      DocumentReference documentRef = collectionRef.doc();

      //print(images);
      await documentRef.set({
        'content': content,
        'rating': rating,
        'trail': ref,
        'user': user,
        'images': images,
      });

      final trailSnapshot = await ref?.get();

      Map<String, dynamic>? trailData =
          trailSnapshot?.data() as Map<String, dynamic>?;
      double currentRating = stringToDouble(trailData?['rating'] ?? 0);

      //print(currentRating);

      double averageRating = (stringToDouble(rating) + currentRating) / 2;
      String averageRatingString = averageRating.toString();

      await ref?.update({'rating': averageRatingString});

      print(images);

      print('Data added to Firestore successfully!');
    } catch (error) {
      print('Error adding data to Firestore: $error');
    }
  }

  Future<String> upload(File file) async {
    final String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    final Reference storageRef = FirebaseStorage.instance.ref().child(fileName);

    final TaskSnapshot snapshot = await storageRef.putFile(file);

    if (snapshot.state == TaskState.success) {
      final String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    }

    throw Exception('Image upload failed.');
  }
}
