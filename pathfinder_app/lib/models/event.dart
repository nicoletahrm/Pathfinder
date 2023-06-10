import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/covert.dart';

class Event {
  final String id;
  final DocumentReference<Object>? organizer;
  final DocumentReference<Object>? trail;
  final List<DocumentReference<Object>?> participants;
  final int maxParticipants;
  final Timestamp time;
  final Timestamp timeAdded;
  final String meetingPlace;

  Event({
    required this.id,
    required this.organizer,
    required this.trail,
    required this.participants,
    required this.maxParticipants,
    required this.time,
    required this.timeAdded,
    required this.meetingPlace,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "organizer": organizer,
      "trail": trail,
      "participants": participants,
      "maxParticipants": maxParticipants,
      "time": time,
      "timeAdded": timeAdded,
      "meetingPlace": meetingPlace,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    final data = json;

    return Event(
      id: data["id"],
      organizer: data["organizer"],
      trail: data["trail"],
      participants: List<DocumentReference<Object>?>.from(data["participants"]),
      maxParticipants: stringToInt(data["maxParticipants"]),
      time: data["time"] as Timestamp,
      timeAdded: data["timeAdded"] as Timestamp,
      meetingPlace: data["meetingPlace"],
    );
  }
}
