import 'package:flutter/material.dart';
import 'package:pathfinder_app/utils/covert.dart';
import '../models/event.dart';
import '../repositories/event_repository.dart';
import '../widgets/custom_circular_progress_indicator.dart';
import '../widgets/custom_nav_bar.dart';
import 'add_event_screen.dart';
import 'event_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final EventRepository eventRepository = EventRepository();
  late List<Event> events = [];

  init() async {
    events = await eventRepository.getEvents();
  }

  @override
  void initState() {
    super.initState();
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
          return buildTrail(context);
        }
      },
    );
  }

  Widget buildTrail(BuildContext context) {
    return Container(
      height: 545.0,
      child: FutureBuilder<void>(
        future: init(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CustomCircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Failed to initialize trails: ${snapshot.error}');
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
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('Event ${index + 1}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventScreen(event: events[index]),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: hexStringToColor("#44564a"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEventScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
