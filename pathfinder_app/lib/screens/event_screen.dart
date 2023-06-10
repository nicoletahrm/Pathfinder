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
import '../widgets/custom_nav_bar.dart';
import '../utils/covert.dart';
import '../widgets/custom_circular_progress_indicator.dart';

class EventScreen extends StatefulWidget {
  final Event event;

  EventScreen({Key? key, required this.event}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final TrailRepository trailRepository = TrailRepository();
  final EventRepository eventRepository = EventRepository();
  final UserRepository userRepository = UserRepository();
  late User user;
  late Trail? trail;
  late List<User?> users;
  late String buttonText = 'Go';

  Future<void> init() async {
    user = await userRepository.getUserByRef(widget.event.organizer);
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(Icons.arrow_back),
                    ),
                  ),
                  SizedBox(height: 100),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 5.0),
                        child: CircleAvatar(
                          radius: 18.0,
                          backgroundImage: AssetImage(user.profilePhoto),
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        children: [
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
                    ],
                  ),
                ],
              ),
              SizedBox(height: 15),
              Text(
                'Date: ${convertTimeToDate(widget.event.time)}',
                style: GoogleFonts.poppins(
                  fontSize: 15.0,
                  fontWeight: FontWeight.normal,
                  color: kDefaultIconDarkColor,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Time: ${convertTime(widget.event.time)}',
                style: GoogleFonts.poppins(
                  fontSize: 15.0,
                  fontWeight: FontWeight.normal,
                  color: kDefaultIconDarkColor,
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Meeting place: ${widget.event.meetingPlace}',
                style: GoogleFonts.poppins(
                  fontSize: 15.0,
                  fontWeight: FontWeight.normal,
                  color: kDefaultIconDarkColor,
                ),
              ),
              SizedBox(height: 15),
              Text(
                'People going: ${widget.event.participants.length}',
                style: GoogleFonts.poppins(
                  fontSize: 15.0,
                  fontWeight: FontWeight.normal,
                  color: kDefaultIconDarkColor,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Max number of people: ${widget.event.maxParticipants}',
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
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
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
                                title: Text('Participants'),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: users.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      User participant = users[index]!;
                                      return ListTile(
                                        leading: CircleAvatar(
                                          radius: 12.0,
                                          backgroundImage: AssetImage(
                                              participant.profilePhoto),
                                        ),
                                        title: Text(participant.username),
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
                            backgroundImage:
                                AssetImage(users[index]!.profilePhoto),
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
                margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() =>
                        buttonText = buttonText == 'Go' ? "Don't go" : 'Go');

                    //Navigator.push<bool>(
                    // context,
                    //MaterialPageRoute(builder: (context) => HomeScreen()),
                    // );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
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
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
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

  // void participate() async {
  //   DocumentReference<Object?> currentUserRef =
  //       await userRepository.getUserRefByEmail(user.email);

  //   await eventRepository.updateParticipants(
  //       widget.event., currentUserRef);
  // }
}
