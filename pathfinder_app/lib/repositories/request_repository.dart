import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/trail_request.dart';

class RequestRepository {
  final FirebaseFirestore database = FirebaseFirestore.instance;

  Future<List<TrailRequest>> getRequests() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await database.collection("request").get();

    return snapshot.docs
        .map((docSnapshot) => TrailRequest.fromJson(docSnapshot.data()))
        .toList();
  }

  addRequest(String title, String source, String sign, String filePath) async {
    try {
      CollectionReference collectionRef = database.collection('request');

      DocumentReference documentRef = collectionRef.doc();

      await documentRef.set({
        'title': title,
        'source': source,
        'sign': sign,
        'filePath': filePath,
        'isAccepted': false,
      });

      print('Data added to Firestore successfully!');
    } catch (error) {
      print('Error adding data to Firestore: $error');
    }
  }
}
