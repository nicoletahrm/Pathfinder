import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/covert.dart';

class Event {
  final DocumentReference<Object>? organizer;
  final DocumentReference<Object>? trail;
  final List<DocumentReference<Object>?> participants;
  final int maxParticipants;
  final Timestamp time;
  final Timestamp timeAdded;

  Event({
    required this.organizer,
    required this.trail,
    required this.participants,
    required this.maxParticipants,
    required this.time,
    required this.timeAdded,
  });

  Map<String, dynamic> toJson() {
    return {
      "organizer": organizer,
      "trail": trail,
      "participants": participants,
      "maxParticipants": maxParticipants,
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
      maxParticipants: stringToInt(data["maxParticipants"]),
      time: data["time"] as Timestamp,
      timeAdded: data["timeAdded"] as Timestamp,
    );
  }
}
