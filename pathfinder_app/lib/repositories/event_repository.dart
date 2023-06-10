import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/event.dart';

class EventRepository {
  final FirebaseFirestore database = FirebaseFirestore.instance;

  Future<List<Event>> getEvents() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await database.collection("event").get();

    return snapshot.docs
        .map((docSnapshot) => Event.fromJson(docSnapshot.data()))
        .toList();
  }

  Future<void> updateParticipants(DocumentReference<Object> eventRef,
      DocumentReference<Object> participantRef) async {
    await FirebaseFirestore.instance
        .collection('event')
        .doc(eventRef.id)
        .update({
      'participants': FieldValue.arrayUnion([participantRef])
    });
  }

  addEvent(Event event) async {
    CollectionReference collectionRef = database.collection('event');
    DocumentReference documentRef = collectionRef.doc();

    await documentRef.set({
      'trail': event.trail,
      'organizer': event.organizer,
      'participants': event.participants,
      'maxParticipant': event.maxParticipants,
      'time': event.time,
      'timeAdded': event.timeAdded,
      'meetingPlace': event.meetingPlace
    });
  }
}
