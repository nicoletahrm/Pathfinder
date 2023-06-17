import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pathfinder_app/utils/covert.dart';
import '../models/event.dart';
import '../models/time.dart';

class EventRepository {
  final FirebaseFirestore database = FirebaseFirestore.instance;

  Future<List<Event>> getEvents() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await database.collection("event").get();

    return snapshot.docs
        .map((docSnapshot) => Event.fromJson(docSnapshot.data()))
        .toList();
  }

  Future<void> updateParticipants(
      Event event, DocumentReference<Object?> participantRef) async {
    await FirebaseFirestore.instance.collection('event').doc(event.id).update({
      'participants': FieldValue.arrayUnion([participantRef]),
      'maxParticipants': event.maxParticipants - 1,
    });
  }

  void addEvent(DocumentReference<Object?> trail, DocumentReference<Object?> user,
      int maxParticipants, String meetingPlace, Time time) async {
    CollectionReference collectionRef = database.collection('event');
    DocumentReference documentRef = collectionRef.doc();

    await documentRef.set({
      'id': documentRef.id,
      'trail': trail,
      'organizer': user,
      'participants': [],
      'maxParticipants': maxParticipants,
      'time': timeToTimestamp(time),
      'timeAdded': new Timestamp.now(),
      'meetingPlace': meetingPlace,
      'comments': [],
    });
  }

  Future<void> updateEvent(
      String id, DocumentReference<Object?> userRef) async {
    try {} catch (e) {
      print('Error updating event: $e');
    }
  }
}
