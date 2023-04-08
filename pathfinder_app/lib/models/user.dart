import 'package:pathfinder_app/models/trail.dart';

class User {
  final int id;
  final String username;
  final String email;
  final List<Trail>? trailsList;

  User(
      {required this.id,
      required this.username,
      required this.email,
      this.trailsList});
}
