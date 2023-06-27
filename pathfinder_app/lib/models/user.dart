import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;

class User {
  final String id;
  final String username;
  final String email;
  final String profilePhoto;
  final String location;
  final List<dynamic> events;

  User(
      {required this.id,
      required this.username,
      required this.email,
      required this.profilePhoto,
      required this.location,
      required this.events});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      profilePhoto: json['profilePhoto'],
      location: json['location'],
      events: List<String>.from(json["events"]),
    );
  }

  factory User.fromFirebaseUser(FirebaseAuth.User firebaseUser) {
    return User(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        username: firebaseUser.displayName ?? '',
        profilePhoto: '',
        location: '',
        events: []);
  }
}
