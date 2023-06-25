import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/trail_map_screen.dart';
import '../utils/covert.dart';

class RouteWidget extends StatefulWidget {
  final GeoPoint destination;
  final String route;
  final String name;

  RouteWidget(
      {Key? key,
      required this.destination,
      required this.name,
      required this.route})
      : super(key: key);

  @override
  _RouteWidgetScreen createState() => _RouteWidgetScreen();
}

class _RouteWidgetScreen extends State<RouteWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => TrailMapScreen(
                destination: GeoPoint(
                  widget.destination.latitude,
                  widget.destination.longitude,
                ),
                route: widget.route,
              ),
            ),
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return hexStringToColor("#44564a");
          }),
        ),
        child: Text(
          widget.name,
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
