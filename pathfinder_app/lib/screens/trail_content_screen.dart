// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:pathfinder_app/models/difficulty.dart';
import 'package:pathfinder_app/utils/constant_colors.dart';

class TrailContentScreen extends StatefulWidget {
  @override
  _TrailContentScreenState createState() => _TrailContentScreenState();
}

class _TrailContentScreenState extends State<TrailContentScreen> {
  Future<void> init() async {}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for the initialization to complete.
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: kButtonColor,
                backgroundColor: Colors.black12.withOpacity(0.5),
              ),
            ],
          ));
        } else if (snapshot.hasError) {
          // Show an error message if the initialization failed.
          return Text('Failed to initialize trails: ${snapshot.error}');
        } else {
          // Build the UI with the initialized trails list.
          return buildTrail(context);
        }
      },
    );
  }

  Widget buildTrail(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(body: GestureDetector(
      onVerticalDragUpdate: (details) {
        int sensitivity = 8;
        if (details.delta.dy > sensitivity) {
          // Down Swipe
          Navigator.of(context).pop();
        } else if (details.delta.dy < -sensitivity) {
          // Up Swipe
        }
      },
    ));
  }
}
