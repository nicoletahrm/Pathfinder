import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final DocumentReference<Object>? organzier;
  final DocumentReference<Object>? trail;
  final List<DocumentReference<Object>?> participants;
  final Timestamp time;
  final Timestamp timeAdded;

  Event({
    required this.organzier,
    required this.trail,
    required this.participants,
    required this.time,
    required this.timeAdded,
  });

  Map<String, dynamic> toJson() {
    return {
      "organzier": organzier,
      "trail": trail,
      "participants": participants,
      "time": time,
      "timeAdded": timeAdded,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    final data = json;

    return Event(
      organzier: data["organzier"],
      trail: data["trail"],
      participants: List<DocumentReference<Object>?>.from(data["participants"]),
      time: data["time"] as Timestamp,
      timeAdded: data["timeAdded"] as Timestamp,
    );
  }
}
