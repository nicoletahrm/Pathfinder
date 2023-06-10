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

    throw Exception(
        'User not found.'); // Throw an exception if the user does not exist
  }

  Future<DocumentReference> getUserRefByEmail(String? email) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await database
        .collection("user")
        .where('email', isEqualTo: email)
        .get();

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = snapshot.docs[0];

    return documentSnapshot.reference;
  }
}
