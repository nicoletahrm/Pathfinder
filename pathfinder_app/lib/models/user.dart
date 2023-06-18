import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String profilePhoto;
  final List<DocumentReference<Object>?> events;

  User(
      {required this.id,
      required this.username,
      required this.email,
      required this.profilePhoto,
      required this.events});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      profilePhoto: json['profilePhoto'],
      events: List<DocumentReference<Object>?>.from(json["events"]),
    );
  }
}
