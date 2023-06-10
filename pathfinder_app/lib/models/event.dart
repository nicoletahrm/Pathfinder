import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pathfinder_app/models/time.dart';
import '../utils/covert.dart';

class Event {
  final DocumentReference<Object>? organizer;
  late final DocumentReference<Object>? trail;
  final List<DocumentReference<Object>?> participants;
  late final int maxParticipants;
  late final Time time;
  final Timestamp timeAdded;
  final String meetingPlace;

  Event({
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
      "organizer": organizer,
      "trail": trail,
      "participants": participants,
      "maxParticipants": maxParticipants,
      "time": timeToTimestamp(time),
      "timeAdded": timeAdded,
      "meetingPlace": meetingPlace,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    final data = json;

    return Event(
      organizer: data["organizer"],
      trail: data["trail"],
      participants: List<DocumentReference<Object>?>.from(data["participants"]),
      maxParticipants: stringToInt(data["maxParticipants"]),
      time: timestampToTime(data["time"]),
      timeAdded: data["timeAdded"],
      meetingPlace: data["meetingPlace"],
    );
  }
}
