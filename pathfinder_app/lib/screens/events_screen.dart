import 'package:flutter/material.dart';
import 'package:pathfinder_app/repositories/trail_respository.dart';
import '../models/event.dart';
import '../widgets/custom_nav_bar.dart';
import '../widgets/event_widget.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final TrailRepository trailRepository = TrailRepository();
  late List<Event> events = [];

  void init() async {
    events = await trailRepository.getEvents();
  }

  @override
  void initState() {
    super.initState();
    init();
    print(events);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event List'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Event ${index + 1}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventWidget(event: events[index]),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
