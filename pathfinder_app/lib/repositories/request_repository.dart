import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/route_request.dart';

class RequestRepository {
  final FirebaseFirestore database = FirebaseFirestore.instance;

  Future<List<RouteRequest>> getRequests() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await database.collection("request").get();

    return snapshot.docs
        .map((docSnapshot) => RouteRequest.fromJson(docSnapshot.data()))
        .toList();
  }

  addRequest(String trailId, String route, String sign, String filePath) async {
    try {
      CollectionReference collectionRef = database.collection('request');
      DocumentReference documentRef = collectionRef.doc();

      await documentRef.set({
        'id': documentRef.id,
        'trailId': trailId,
        'route': route,
        'sign': sign,
        'filePath': "data/user/0/com.example.pathfinder_app/cache/" + filePath,
        'isAccepted': false,
      });

      print('Data added to Firestore successfully!');
    } catch (error) {
      print('Error adding data to Firestore: $error');
    }
  }

  Future<void> updateRequest(String id, bool isAccepted) async {
    try {
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('request');

      QuerySnapshot querySnapshot =
          await collectionRef.where('id', isEqualTo: id).get();

      if (querySnapshot.docs.isNotEmpty) {
        await collectionRef.doc(id).update({'isAccepted': isAccepted});

        print('Request data updated successfully!');
      } else {
        print('Request not found!');
      }
    } catch (error) {
      print('Error updating request data: $error');
    }
  }

  Future<void> deleteRequest(String id) async {
    try {
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('request');

      QuerySnapshot querySnapshot =
          await collectionRef.where('id', isEqualTo: id).get();

      if (querySnapshot.docs.isNotEmpty) {
        await collectionRef.doc(id).delete();

        print('Request deleted successfully!');
      } else {
        print('Request not found!');
      }
    } catch (error) {
      print('Error deleting request: $error');
    }
  }
}
