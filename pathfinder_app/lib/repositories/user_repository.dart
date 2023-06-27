import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pathfinder_app/models/user.dart';

class UserRepository {
  final FirebaseFirestore database = FirebaseFirestore.instance;

  Future addUserDetails(String username, String email) async {
    CollectionReference collectionRef = database.collection('review');
    DocumentReference documentRef = collectionRef.doc();

    await FirebaseFirestore.instance.collection("user").add({
      'id': documentRef.id,
      'username': username,
      'email': email,
      'profilePhoto':
          '/data/user/0/com.example.pathfinder_app/cache/85dbf4a7-39df-4b80-a1d5-2e288854f72c/3656f16682220d776b33d9997083dd7e.jpg',
      'events': [],
      'location': '~'
    });
  }

  Future<User> getUserByEmail(String? email) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await database
        .collection("user")
        .where('email', isEqualTo: email)
        .get();

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = snapshot.docs[0];

    print(User.fromJson(documentSnapshot.data() as Map<String, dynamic>));

    return User.fromJson(documentSnapshot.data() as Map<String, dynamic>);
  }

  Future<User> getUserById(String id) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await database.collection("user").where('id', isEqualTo: id).get();

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = snapshot.docs[0];

    return User.fromJson(documentSnapshot.data() as Map<String, dynamic>);
  }

  Future<void> addEventToUser(User user, String eventId) async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('user');

    QuerySnapshot querySnapshot =
        await collectionRef.where('id', isEqualTo: user.id).get();

    if (querySnapshot.docs.isNotEmpty) {
      await collectionRef.doc(user.id).update({
        'events': FieldValue.arrayUnion([eventId]),
      });
    }
  }

  Future<void> removeEventFromUser(User user, String eventId) async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('user');

    QuerySnapshot querySnapshot =
        await collectionRef.where('id', isEqualTo: user.id).get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot userSnapshot = querySnapshot.docs.first;
      List<String> eventsList = List<String>.from(userSnapshot.get('events'));

      if (eventsList.contains(eventId)) {
        eventsList.remove(eventId);

        await collectionRef.doc(userSnapshot.id).update({
          'events': eventsList,
        });
      }
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
