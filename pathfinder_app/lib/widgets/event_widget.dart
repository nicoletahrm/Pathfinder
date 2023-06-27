import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pathfinder_app/repositories/trail_respository.dart';
import 'package:pathfinder_app/repositories/user_repository.dart';
import 'package:pathfinder_app/widgets/reusable_widget.dart';
import '../models/event.dart';
import '../models/trail.dart';
import '../models/user.dart';
import '../repositories/event_repository.dart';
import '../screens/events_screen.dart';
import '../utils/covert.dart';
import '../utils/fonts.dart';
import 'custom_circular_progress_indicator.dart';

class EventWidget extends StatefulWidget {
  final Event event;
  final String email;

  EventWidget({Key? key, required this.event, required this.email})
      : super(key: key);

  @override
  _EventWidgetState createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  final TrailRepository trailRepository = TrailRepository();
  final EventRepository eventRepository = EventRepository();
  final UserRepository userRepository = UserRepository();
  late User currentUser;
  late User organizer;
  late Trail? trail;
  late List<User?> users = [];
  late String buttonText;

  Future<void> init() async {
    organizer = await userRepository.getUserById(widget.event.organizer);
    trail = await trailRepository.getTrailById(widget.event.trail!.id);
    users = await fetchParticipants();
    currentUser = await userRepository.getUserByEmail(widget.email);

    if (widget.event.participants.contains(currentUser.id)) {
      buttonText = "Don't go";
    } else {
      buttonText = "Go";
    }
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
                              backgroundImage:
                                  AssetImage(organizer.profilePhoto),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            organizer.username,
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
            // Container(
            //   child: TrailWidget(
            //     index: 0,
            //     margin: 1,
            //     trail: trail!,
            //   ),
            // ),
            Container(
              margin: EdgeInsets.only(
                top: 0.0,
                bottom: 10.0,
                left: 30.0,
                right: 30.0,
              ),
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
                                style: darkBoldFont,
                              ),
                              content: SizedBox(
                                width: double.maxFinite,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: users.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ListTile(
                                      leading: CircleAvatar(
                                        radius: 20.0,
                                        backgroundImage: AssetImage(
                                            users[index]!.profilePhoto),
                                      ),
                                      title: Text(
                                        users[index]!.username,
                                        style: darkNormalFont,
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
                                  child: Text('Close', style: darkNormalFont),
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
            normalButton(context, buttonText, () async {
              if (widget.event.maxParticipants == 0) {
                showValidationDialogWidget(
                  context,
                  'Fail',
                  'No free spots left.',
                );
              } else {
                bool isParticipant =
                    widget.event.participants.contains(currentUser.id);

                if (isParticipant == true) {
                  await eventRepository.removeParticipant(
                      widget.event, currentUser.id);
                  await userRepository.removeEventToUser(
                      currentUser.id, widget.event.id);
                } else {
                  await eventRepository.updateParticipants(
                      widget.event, currentUser.id);
                  await userRepository.addEventToUser(
                      currentUser.id, widget.event.id);
                }

                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventsScreen(),
                    ),
                  );
                });
              }
            }),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<List<User>> fetchParticipants() async {
    List<User> participants = [];

    for (String participantId in widget.event.participants) {
      User participant = await userRepository.getUserById(participantId);
      participants.add(participant);
    }

    return participants;
  }
}
