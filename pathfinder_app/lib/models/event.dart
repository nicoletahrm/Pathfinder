import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final DocumentReference<Object?>? organzier;
  final DocumentReference<Object?>? trail;
  final List<DocumentReference<Object?>?> participants;

  Event({
    required this.organzier,
    required this.trail,
    required this.participants,
  });

  Map<String, dynamic> toJson() {
    return {
      "organzier": organzier,
      "trail": trail,
      "participants": participants,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    final data = json;

    return Event(
      organzier: data["organzier"],
      trail: data["trail"],
      participants: data["participants"],
    );
  }
}
