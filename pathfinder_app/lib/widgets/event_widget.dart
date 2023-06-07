import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pathfinder_app/repositories/trail_respository.dart';
import '../models/event.dart';
import '../models/trail.dart';
import '../models/user.dart';
import '../utils/colors_utils.dart';
import '../utils/covert.dart';
import 'custom_circular_progress_indicator.dart';

class EventWidget extends StatefulWidget {
  final Event event;

  EventWidget({Key? key, required this.event}) : super(key: key);

  @override
  _EventWidgetState createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  final TrailRepository trailRepository = TrailRepository();
  late User user;
  late Trail? trail;
  late List<User?> users;

  Future<void> init() async {
    user = await trailRepository.getUserByRef(widget.event.organizer);
    trail = await trailRepository.getTrailByRef(widget.event.trail);
    users = await fetchParticipants();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<void>(
        future: init(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CustomCircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Failed to initialize event: ${snapshot.error}');
          } else {
            return buildEvent(context);
          }
        },
      ),
    );
  }

  Widget buildEvent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Organizer: ${user.username}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Trail: ${trail!.title}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Time: ${convertTime(widget.event.time)}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Participants: ${widget.event.participants.length}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Number of max participants: ${widget.event.maxParticipants}',
              style: TextStyle(fontSize: 18),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.event.participants.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
                    width: 500,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(user.profilePhoto),
                        ),
                        SizedBox(width: 15),
                        Text(
                          users[index]!.username,
                          style: GoogleFonts.poppins(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: hexStringToColor("#44564a"),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<User>> fetchParticipants() async {
    List<User> participants = [];

    for (DocumentReference<Object>? participantRef
        in widget.event.participants) {
      if (participantRef != null) {
        User participant = await trailRepository.getUserByRef(participantRef);
        participants.add(participant);
      }
    }

    return participants;
  }
}
