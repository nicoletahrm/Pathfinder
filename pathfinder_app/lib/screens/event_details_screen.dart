import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pathfinder_app/repositories/trail_respository.dart';
import 'package:pathfinder_app/repositories/user_repository.dart';
import '../models/event.dart';
import '../models/trail.dart';
import '../models/user.dart';
import '../repositories/event_repository.dart';
import '../utils/covert.dart';
import '../widgets/custom_circular_progress_indicator.dart';
import '../widgets/event_widget.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  EventDetailsScreen({Key? key, required this.event}) : super(key: key);

  @override
  _EventWidgetScreenState createState() => _EventWidgetScreenState();
}

class _EventWidgetScreenState extends State<EventDetailsScreen> {
  final TrailRepository trailRepository = TrailRepository();
  final EventRepository eventRepository = EventRepository();
  final UserRepository userRepository = UserRepository();
  late User user;
  late DocumentReference<Object?> userRef;
  late Trail? trail;
  late List<User?> users;
  late String buttonText = 'Go';

  Future<void> init() async {
    user = await userRepository.getUserByRef(widget.event.organizer);
    trail = await trailRepository.getTrailByRef(widget.event.trail);
    users = await fetchParticipants();
    userRef = await userRepository.getUserRefByEmail(user.email);
  }

  @override
  void initState() {
    super.initState();
    init();
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
          return buildTrail(context);
        }
      },
    );
  }

  Widget buildTrail(BuildContext context) {
    return Container(
      child: FutureBuilder<void>(
        future: init(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          return buildEvent(context);
        },
      ),
    );
  }

  Widget buildEvent(BuildContext context) {
    //   Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
            child: Container(
      padding: EdgeInsets.only(
        top: 30.0,
        bottom: 0.0,
        left: 20.0,
        right: 20.0,
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(Icons.arrow_back),
            ),
          ),
          EventWidget(
            event: widget.event,
          ),
          Container(
            margin: EdgeInsets.only(
                top: 0.0, bottom: 10.0, left: 30.0, right: 30.0),
            child: Row(
              children: List<Widget>.generate(
                widget.event.participants.length,
                (index) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'People going',
                              style: GoogleFonts.poppins(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                                color: kDefaultIconDarkColor,
                              ),
                            ),
                            content: SizedBox(
                              width: double.maxFinite,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: users.length,
                                itemBuilder: (BuildContext context, int index) {
                                  User participant = users[index]!;
                                  return ListTile(
                                    leading: CircleAvatar(
                                      radius: 20.0,
                                      backgroundImage:
                                          AssetImage(participant.profilePhoto),
                                    ),
                                    title: Text(
                                      participant.username,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.normal,
                                        color: kDefaultIconDarkColor,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 5.0),
                      child: CircleAvatar(
                        radius: 12.0,
                        backgroundImage: AssetImage(users[index]!.profilePhoto),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: ElevatedButton(
              onPressed: () async {
                if (widget.event.maxParticipants < 0) {
                  AlertDialog(
                    title: Text(''),
                    content: Text('Max participant is full'),
                    actions: [
                      ElevatedButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                } else {
                  await eventRepository.updateParticipants(
                      widget.event, userRef);
                  setState(() =>
                      buttonText = buttonText == 'Go' ? "Don't go" : 'Go');
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.black26;
                  }
                  return hexStringToColor("#44564a");
                }),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              child: Text(
                buttonText,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    )));
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
