import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pathfinder_app/utils/covert.dart';
import '../models/event.dart';
import '../models/time.dart';
import '../models/user.dart';

class EventRepository {
  final FirebaseFirestore database = FirebaseFirestore.instance;

  Future<List<Event>> getEvents() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await database.collection("event").get();

    return snapshot.docs
        .map((docSnapshot) => Event.fromJson(docSnapshot.data()))
        .toList();
  }

  Future<void> updateParticipants(Event event, User user) async {
    await FirebaseFirestore.instance.collection('event').doc(event.id).update({
      'participants': FieldValue.arrayUnion([user.id]),
    });
  }

  Future<void> removeParticipant(Event event, String participantId) async {
    await FirebaseFirestore.instance.collection('event').doc(event.id).update({
      'participants': FieldValue.arrayRemove([participantId]),
    });
  }

  addEvent(String trailId, String userId, int maxParticipants,
      String meetingPlace, Time time) async {
    CollectionReference collectionRef = database.collection('event');
    DocumentReference documentRef = collectionRef.doc();

    await documentRef.set({
      'id': documentRef.id,
      'trail': trailId,
      'organizer': userId,
      'participants': [],
      'maxParticipants': maxParticipants,
      'time': timeToTimestamp(time),
      'timeAdded': new Timestamp.now(),
      'meetingPlace': meetingPlace,
      'comments': [],
    });
  }

  Future<Event> getEventById(String eventId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await database
        .collection("event")
        .where('id', isEqualTo: eventId)
        .get();

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = snapshot.docs[0];

    return Event.fromJson(documentSnapshot.data() as Map<String, dynamic>);
  }
}
