import 'package:pathfinder_app/models/event.dart';
import 'package:pathfinder_app/repositories/event_repository.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';
import '../utils/fonts.dart';
import '../widgets/custom_circular_progress_indicator.dart';
import '../widgets/custom_nav_bar.dart';
import 'package:flutter/material.dart';
import '../widgets/event_widget.dart';
import 'dart:async';

class UserHikesScreen extends StatefulWidget {
  final String email;

  UserHikesScreen({Key? key, required this.email}) : super(key: key);

  @override
  _UserHikesScreenState createState() => _UserHikesScreenState();
}

class _UserHikesScreenState extends State<UserHikesScreen> {
  late User user;
  final UserRepository userRepository = UserRepository();
  final EventRepository eventRepository = EventRepository();
  late List<Event> events;

  init() async {
    user = await userRepository.getUserByEmail(widget.email);
    events = await fetchEvents();
    //init();
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
            ),
          );
        } else if (snapshot.hasError) {
          return Text(
              'Failed to initialize UserHikesScreen: ${snapshot.error}');
        } else {
          return buildEventWidget(context);
        }
      },
    );
  }

  Widget buildEventWidget(BuildContext context) {
    if (events.isEmpty) {
      return Scaffold(
        body: Container(
            padding: EdgeInsets.only(
              top: 80.0,
              bottom: 0.0,
              left: 20.0,
              right: 20.0,
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Your hikes.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: "ProximaNovaBold",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25.0),
              Center(
                child: Text("No hikes found.", style: darkBoldFont),
              ),
            ])),
        bottomNavigationBar: CustomBottomNavBar(),
      );
    } else
      return Scaffold(
        backgroundColor: kDefaultIconLightColor,
        body: Container(
          padding: EdgeInsets.only(
            top: 80.0,
            bottom: 0.0,
            left: 20.0,
            right: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Your hikes.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: "ProximaNovaBold",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25.0),
              Flexible(
                child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    return Container(
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
                      child: EventWidget(
                          event: events[index], email: widget.email),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(),
      );
  }

  Future<List<Event>> fetchEvents() async {
    List<Event> events = [];

    for (String eventId in user.events) {
      Event event = await eventRepository.getEventById(eventId);
      events.add(event);
    }
    return events;
  }
}
