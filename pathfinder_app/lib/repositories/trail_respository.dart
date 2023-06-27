import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/trail.dart';

class TrailRepository {
  final FirebaseFirestore database = FirebaseFirestore.instance;

  Future<List<Trail>> getAllTrails() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await database.collection("trail").orderBy('title').get();

    return snapshot.docs
        .map((docSnapshot) => Trail.fromJson(docSnapshot.data()))
        .toList();
  }

  Future<List<Trail>> getTrailsByDifficulty(String difficulty) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await database
        .collection("trail")
        .orderBy('title')
        .where('difficulty', isEqualTo: difficulty)
        .get();

    return snapshot.docs
        .map((docSnapshot) => Trail.fromJson(docSnapshot.data()))
        .toList();
  }

  Future<Trail> getTrailById(String trailId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await database
        .collection("trail")
        .where('id', isEqualTo: trailId)
        .get();

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = snapshot.docs[0];

    return Trail.fromJson(documentSnapshot.data() as Map<String, dynamic>);
  }

  Future<Trail> getTrailByTitle(String title) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await database
        .collection("trail")
        .where('title', isEqualTo: title)
        .get();

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = snapshot.docs[0];

    return Trail.fromJson(documentSnapshot.data() as Map<String, dynamic>);
  }

  Future<void> addNewTrail(Trail trail) async {
    try {
      CollectionReference trailsCollection =
          FirebaseFirestore.instance.collection('trail');

      DocumentReference documentReference =
          await trailsCollection.add(trail.toJson());
      String trailId = documentReference.id;

      trail = Trail(
        id: trailId,
        rating: trail.rating,
        title: trail.title,
        content: trail.content,
        coverImage: trail.coverImage,
        distance: trail.distance,
        difficulty: trail.difficulty,
        altitude: trail.altitude,
        destination: trail.destination,
        images: trail.images,
        routes: trail.routes,
      );

      await documentReference.set(trail.toJson());

      print('Trail added successfully!');
    } catch (e) {
      print('Error adding trail: $e');
    }
  }

  Future<void> updateTrailRoutes(
      String id, String routeName, String filePath) async {
    try {
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('trail');

      QuerySnapshot querySnapshot =
          await collectionRef.where('id', isEqualTo: id).get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> existingRoutes =
            querySnapshot.docs.first.get('routes') ?? {};

        Map<String, String> updatedRoutes =
            Map<String, String>.from(existingRoutes);

        updatedRoutes[filePath] = routeName;

        await collectionRef.doc(id).update({'routes': updatedRoutes});

        print('Routes updated successfully!');
      } else {
        print('Trail not found!');
      }
    } catch (error) {
      print('Error updating routes: $error');
    }
  }
}
