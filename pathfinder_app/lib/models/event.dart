import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pathfinder_app/models/time.dart';
import '../utils/covert.dart';

class Event {
  final String id;
  final String organizer;
  late final DocumentReference<Object?>? trail;
  final List<dynamic> participants;
  late final int maxParticipants;
  late final Time time;
  final Timestamp timeAdded;
  final String meetingPlace;
  final List<dynamic> comments;

  Event({
    required this.id,
    required this.organizer,
    required this.trail,
    required this.participants,
    required this.maxParticipants,
    required this.time,
    required this.timeAdded,
    required this.meetingPlace,
    required this.comments,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "organizer": organizer,
      "trail": trail,
      "participants": participants,
      "maxParticipants": maxParticipants,
      "time": timeToTimestamp(time),
      "timeAdded": timeAdded,
      "meetingPlace": meetingPlace,
      "comments": comments,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    final data = json;

    return Event(
      id: data["id"],
      organizer: data["organizer"],
      trail: data["trail"],
      participants: List<String>.from(data["participants"]),
      maxParticipants: data["maxParticipants"],
      time: timestampToTime(data["time"]),
      timeAdded: data["timeAdded"],
      meetingPlace: data["meetingPlace"],
      comments: List<DocumentReference<Object>?>.from(data["comments"]),
    );
  }
}
