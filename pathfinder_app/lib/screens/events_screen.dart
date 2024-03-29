import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/event.dart';
import '../repositories/event_repository.dart';
import '../utils/fonts.dart';
import '../widgets/custom_circular_progress_indicator.dart';
import '../widgets/custom_nav_bar.dart';
import 'add_event_screen.dart';
import '../widgets/event_widget.dart';

class EventsScreen extends StatefulWidget {
  EventsScreen({Key? key}) : super(key: key);

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final EventRepository eventRepository = EventRepository();
  late List<Event> events;
  final currentUser = FirebaseAuth.instance.currentUser;

  Future<void> init() async {
    events = await eventRepository.getEvents();
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
            children: const [
              CustomCircularProgressIndicator(),
            ],
          ));
        } else if (snapshot.hasError) {
          return Text('Failed to initialize events: ${snapshot.error}');
        } else {
          return buildEvents(context);
        }
      },
    );
  }

  Widget buildEvents(BuildContext context) {
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
                    "Let's find some hikes!",
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddEventScreen(email: currentUser!.email!),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: CustomBottomNavBar(),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(
            top: 60.0,
            bottom: 0.0,
            left: 20.0,
            right: 20.0,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Let's find some hikes!",
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
              SizedBox(
                height: 20.0,
              ),
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
                          email: currentUser!.email!, event: events[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEventScreen(email: currentUser!.email!),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
