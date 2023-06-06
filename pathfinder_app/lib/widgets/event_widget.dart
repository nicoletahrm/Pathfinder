import 'package:flutter/material.dart';
import 'package:pathfinder_app/repositories/trail_respository.dart';
import '../models/event.dart';
import '../models/user.dart';
import 'custom_circular_progress_indicator.dart';

class EventWidget extends StatefulWidget {
  final Event event;

  EventWidget({Key? key, required this.event}) : super(key: key);

  @override
  _EventWidgetState createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  final TrailRepository trailRepository = TrailRepository();
  late User user;

  Future<void> init() async {
    user = await trailRepository.getUserByRef(widget.event.organzier);
    print(user.username);
  }

  @override
  Widget build(BuildContext context) {
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
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Organizer: ${user.username}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Trail: ${widget.event.trail}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Time: ${widget.event.time}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Participants: ${widget.event.participants.length}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
