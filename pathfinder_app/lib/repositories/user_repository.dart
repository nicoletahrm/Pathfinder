import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

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

  Future<void> addEventToUser(User user, String id) async {
    await database.doc(user.id).update({
      'events': FieldValue.arrayUnion([id]),
    });
  }

  Future<void> removeEventToUser(User user, String id) async {
    await database.doc(user.id).update({
      'events': FieldValue.arrayRemove([id]),
    });
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
}
