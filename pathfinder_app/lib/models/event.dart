import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final DocumentReference<Object>? organizer;
  final DocumentReference<Object>? trail;
  final List<DocumentReference<Object>?> participants;
  final Timestamp time;
  final Timestamp timeAdded;

  Event({
    required this.organizer,
    required this.trail,
    required this.participants,
    required this.time,
    required this.timeAdded,
  });

  Map<String, dynamic> toJson() {
    return {
      "organizer": organizer,
      "trail": trail,
      "participants": participants,
      "time": time,
      "timeAdded": timeAdded,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    final data = json;

    return Event(
      organizer: data["organizer"],
      trail: data["trail"],
      participants: List<DocumentReference<Object>?>.from(data["participants"]),
      time: data["time"] as Timestamp,
      timeAdded: data["timeAdded"] as Timestamp,
    );
  }
}
