import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/trail.dart';
import 'dart:io';

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
