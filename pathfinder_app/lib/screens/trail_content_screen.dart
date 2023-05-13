// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:pathfinder_app/utils/constant_colors.dart';

class TrailContentScreen extends StatefulWidget {
  final int index;
  final String title, content;

  const TrailContentScreen({
    super.key,
    required this.index,
    required this.title,
    required this.content,
  });

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
          return Text('Failed to initialize trail: ${snapshot.error}');
        } else {
          return buildTrail(context);
        }
      },
    );
  }

  Widget buildTrail(BuildContext context) {
    //Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: kLightColor,
        body: GestureDetector(
            onVerticalDragUpdate: (details) {
              int sensitivity = 8;
              if (details.delta.dy > sensitivity) {
                // Down Swipe
                Navigator.of(context).pop();
              } else if (details.delta.dy < -sensitivity) {
                // Up Swipe
              }
            },
            child: SingleChildScrollView(
              child: Container(
                  padding: const EdgeInsets.only(
                      top: 80.0, bottom: 0.0, left: 20.0, right: 20.0),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.title,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 28.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: "ProximaNovaBold",
                            ),
                          ),
                          const SizedBox(height: 28.0),
                          Text(
                            widget.content,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontFamily: "ProximaNovaBold",
                            ),
                          )
                        ])
                  ])),
            )));
  }
}
