import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'event_details_screen.dart';

class UserHikesScreen extends StatefulWidget {
  final String email;

  UserHikesScreen({Key? key, required this.email}) : super(key: key);

  @override
  _UserHikesScreenState createState() => _UserHikesScreenState();
}

class _UserHikesScreenState extends State<UserHikesScreen> {
  late DocumentReference ref;
  late User user;
  final UserRepository userRepository = UserRepository();
  final EventRepository eventRepository = EventRepository();
  late List<Event> events;
  late String query;
  String selectedDifficulty = '';

  Future<void> init() async {
    print(widget.email);
    ref = (await userRepository.getUserRefByEmail(widget.email));
    user = await userRepository.getUserByRef(ref);
    events = await fetchEvents();
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
          return Text('Failed to initialize hikes: ${snapshot.error}');
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
    }

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
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EventDetailsScreen(event: events[index]),
                        ),
                      );
                    },
                    child: Container(
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
                      child: EventWidget(event: events[index]),
                    ),
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

    for (DocumentReference<Object>? ref in user.events) {
      if (ref != null) {
        Event comment = await eventRepository.getEventByRef(ref);
        events.add(comment);
      }
    }
    return events;
  }
}
