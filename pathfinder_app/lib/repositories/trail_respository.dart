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

  Future<Trail> getTrailByTitle(String trailTitle) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await database
        .collection("trail")
        .where('title', isEqualTo: trailTitle)
        .get();

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = snapshot.docs[0];

    Map<String, dynamic>? data = documentSnapshot.data();
    return Trail.fromJson(data!);
  }

  Future<DocumentReference> getRefTrailByTitle(String trailTitle) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await database
        .collection("trail")
        .where('title', isEqualTo: trailTitle)
        .get();

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = snapshot.docs[0];

    return documentSnapshot.reference;
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
}
