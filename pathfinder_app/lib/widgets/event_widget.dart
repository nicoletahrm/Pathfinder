import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pathfinder_app/repositories/trail_respository.dart';
import 'package:pathfinder_app/repositories/user_repository.dart';
import 'package:pathfinder_app/widgets/trail_widget.dart';
import '../models/event.dart';
import '../models/trail.dart';
import '../models/user.dart';
import '../repositories/event_repository.dart';
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
  final EventRepository eventRepository = EventRepository();
  final UserRepository userRepository = UserRepository();
  late User user;
  late DocumentReference<Object?> userRef;
  late Trail? trail;
  late List<User?> users = [];
  late String buttonText;

  Future<void> init() async {
    user = await userRepository.getUserByRef(widget.event.organizer);
    trail = await trailRepository.getTrailByRef(widget.event.trail);
    users = await fetchParticipants();
    userRef = await userRepository.getUserRefByEmail(user.email);
  }

  @override
  void initState() {
    super.initState();
    //init();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomCircularProgressIndicator(),
            ],
          ));
        } else if (snapshot.hasError) {
          return Text('Failed to initialize event: ${snapshot.error}');
        } else {
          return buildEventWidget(context);
        }
      },
    );
  }

  Widget buildEventWidget(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 8.0),
                            child: CircleAvatar(
                              radius: 18.0,
                              backgroundImage: AssetImage(user.profilePhoto),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            user.username,
                            style: GoogleFonts.poppins(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                              color: hexStringToColor("#44564a"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              'Date: ${widget.event.time.getDateWithoutTime()}',
              style: GoogleFonts.poppins(
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
                color: kDefaultIconDarkColor,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Time: ${widget.event.time.getFormattedTime()}',
              style: GoogleFonts.poppins(
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
                color: kDefaultIconDarkColor,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Meeting place: ${widget.event.meetingPlace}',
              style: GoogleFonts.poppins(
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
                color: kDefaultIconDarkColor,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'People going: ${widget.event.participants.length}',
              style: GoogleFonts.poppins(
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
                color: kDefaultIconDarkColor,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Free spots: ${widget.event.maxParticipants - widget.event.participants.length}',
              style: GoogleFonts.poppins(
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
                color: kDefaultIconDarkColor,
              ),
            ),
            SizedBox(height: 20),
            Container(
              child: TrailWidget(
                index: 0,
                margin: 1,
                trail: trail!,
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
        User participant = await userRepository.getUserByRef(participantRef);
        participants.add(participant);
      }
    }

    return participants;
  }
}
