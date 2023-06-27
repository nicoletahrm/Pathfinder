import 'package:flutter/material.dart';
import 'package:pathfinder_app/repositories/trail_respository.dart';
import 'package:pathfinder_app/repositories/user_repository.dart';
import 'package:pathfinder_app/widgets/custom_nav_bar.dart';
import '../models/event.dart';
import '../models/trail.dart';
import '../models/user.dart';
import '../repositories/event_repository.dart';
import '../utils/fonts.dart';
import '../widgets/custom_circular_progress_indicator.dart';
import '../widgets/event_widget.dart';
import '../widgets/reusable_widget.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;
  final String email;

  EventDetailsScreen({Key? key, required this.event, required this.email})
      : super(key: key);

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final TrailRepository trailRepository = TrailRepository();
  final EventRepository eventRepository = EventRepository();
  final UserRepository userRepository = UserRepository();
  late User currentUser;
  late Trail trail;
  late List<User?> users;
  late String buttonText;

  @override
  void initState() {
    super.initState();
  }

  Future<void> init() async {
    trail = await trailRepository.getTrailById(widget.event.trail);
    users =
        await userRepository.getEventParticipants(widget.event.participants);
    currentUser = await userRepository.getUserByEmail(widget.email);

    if (widget.event.participants.contains(currentUser.id)) {
      buttonText = "Don't go";
    } else {
      buttonText = "Go";
    }
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
          return buildEvent(context);
        }
      },
    );
  }

  Widget buildEvent(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 30.0,
              horizontal: 20.0,
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
                SizedBox(height: 30),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: Offset(0, 1),
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                  child: EventWidget(event: widget.event, email: widget.email),
                ),
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
                                      child:
                                          Text('Close', style: darkNormalFont),
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
                      await userRepository.removeEventFromUser(
                          currentUser, widget.event.id);
                    } else {
                      await eventRepository.updateParticipants(
                          widget.event, currentUser);
                      await userRepository.addEventToUser(
                          currentUser, widget.event.id);
                    }

                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetailsScreen(
                              event: widget.event, email: widget.email),
                        ),
                      );
                    });
                  }
                }),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
