import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pathfinder_app/models/user.dart';

class UserRepository {
  final FirebaseFirestore database = FirebaseFirestore.instance;

  Future<User> getUserByRef(DocumentReference<Object?>? ref) async {
    final userSnapshot = await ref!.get();

    if (userSnapshot.exists) {
      final userData = userSnapshot.data() as Map<String, dynamic>;
      return User.fromJson(userData);
    }

    throw Exception('User not found.');
  }

  Future<DocumentReference> getUserRefByEmail(String? email) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await database
        .collection("user")
        .where('email', isEqualTo: email)
        .get();

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = snapshot.docs[0];

    return documentSnapshot.reference;
  }

  Future<List<DocumentReference<Object>?>?> getUserEvents(String? email) async {
    final userDocRef = await getUserRefByEmail(email);
    final userDocSnapshot = await userDocRef.get();

    if (userDocSnapshot.exists) {
      final userData = userDocSnapshot.data() as Map<String, dynamic>;
      final user = User.fromJson(userData);

      return user.events;
    }
    return null;
  }

  Future<void> addEventToUser(
      DocumentReference<Object?> userRef, String eventId) async {
    User user = await getUserByRef(userRef);
    DocumentReference<Object>? eventRef = database.doc('event/$eventId');
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('user');

    QuerySnapshot querySnapshot =
        await collectionRef.where('id', isEqualTo: user.id).get();

    if (querySnapshot.docs.isNotEmpty) {
      await collectionRef.doc(user.id).update({
        'events': FieldValue.arrayUnion([eventRef]),
      });
    }
  }

  Future<void> removeEventToUser(
      DocumentReference<Object?> userRef, String eventId) async {
    User user = await getUserByRef(userRef);
    DocumentReference<Object>? eventRef = database.doc('event/$eventId');
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('user');

    QuerySnapshot querySnapshot =
        await collectionRef.where('id', isEqualTo: user.id).get();

    if (querySnapshot.docs.isNotEmpty) {
      await collectionRef.doc(user.id).update({
        'events': FieldValue.arrayRemove([eventRef]),
      });
    }
  }

  Future<void> updateUser(
      String id, String username, String email, String location) async {
    try {
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('user');

      QuerySnapshot querySnapshot =
          await collectionRef.where('id', isEqualTo: id).get();

      if (querySnapshot.docs.isNotEmpty) {
        await collectionRef.doc(id).update({
          'username': username,
          'email': email,
          'location': location,
        });

        print('User data updated successfully!');
      } else {
        print('User not found!');
      }
    } catch (error) {
      print('Error updating user data: $error');
    }
  }

  Future<List<User>> getEventParticipants(
      List<DocumentReference<Object>?> eventParticipants) async {
    List<User> participants = [];

    for (DocumentReference<Object>? participantRef in eventParticipants) {
      if (participantRef != null) {
        User participant = await getUserByRef(participantRef);
        participants.add(participant);
      }
    }
    return participants;
  }
}
