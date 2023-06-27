import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pathfinder_app/models/user.dart';

class UserRepository {
  final FirebaseFirestore database = FirebaseFirestore.instance;

  Future<User> getUserByEmail(String? email) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await database
        .collection("user")
        .where('email', isEqualTo: email)
        .get();

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = snapshot.docs[0];

    return User.fromJson(documentSnapshot.data() as Map<String, dynamic>);
  }

  Future<User> getUserById(String id) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await database.collection("user").where('id', isEqualTo: id).get();

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = snapshot.docs[0];

    return User.fromJson(documentSnapshot.data() as Map<String, dynamic>);
  }

  Future<void> addEventToUser(String userId, String eventId) async {
    User user = await getUserById(userId);
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

  Future<void> removeEventToUser(String userId, String eventId) async {
    User user = await getUserById(userId);
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

  Future<void> updateUser(String id, String username, String email,
      String location, String profilePhoto) async {
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
          'profilePhoto': profilePhoto,
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
      List<dynamic> eventParticipants) async {
    List<User> participants = [];

    for (String id in eventParticipants) {
      User participant = await getUserById(id);
      participants.add(participant);
    }

    return participants;
  }
}
