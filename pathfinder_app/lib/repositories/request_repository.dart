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
}
