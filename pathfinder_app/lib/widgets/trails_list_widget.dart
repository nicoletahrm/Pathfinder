import 'package:flutter/material.dart';
import 'package:pathfinder_app/widgets/trail_widget.dart';
import '../models/trail.dart';
import 'custom_circular_progress_indicator.dart';

class TrailsList extends StatelessWidget {
  final List<Trail> trails;

  const TrailsList({Key? key, required this.trails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 545.0,
      child: FutureBuilder<void>(
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CustomCircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Failed to initialize trails: ${snapshot.error}');
          } else {
            return buildTrailsList(context);
          }
        },
      ),
    );
  }

  Widget buildTrailsList(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: trails.length,
      itemBuilder: (BuildContext context, int index) {
        return TrailWidget(
            index: index, margin: index == 0 ? 0 : 20.0, trail: trails[index]);
      },
    );
  }
}
