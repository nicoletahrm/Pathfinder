import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pathfinder_app/models/difficulty.dart';
import 'package:pathfinder_app/utils/constant_colors.dart';

import '../utils/colors_utils.dart';

class TrailDetailsScreen extends StatefulWidget {
  final int index;
  final String title, description, coverImage, distance, altitude;
  final double rating;
  final Difficulty difficulty;

  const TrailDetailsScreen(
      {super.key,
      required this.index,
      required this.title,
      required this.description,
      required this.coverImage,
      required this.distance,
      required this.altitude,
      required this.difficulty,
      required this.rating});

  @override
  // ignore: library_private_types_in_public_api
  _TrailDetailsScreenState createState() => _TrailDetailsScreenState();
}

class _TrailDetailsScreenState extends State<TrailDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: kLightColor,
        body: SingleChildScrollView(
            child: Form(
                child: Stack(
          children: [
            Hero(
              tag: "trail${widget.index}",
              child: Image.asset(widget.coverImage,
                  height: size.height, width: size.width, fit: BoxFit.cover),
            ),
            Container(
                height: size.height,
                width: size.width,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black,
                    ],
                    stops: [
                      0.6,
                      0.9,
                    ],
                  ),
                )),
            GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Padding(
                  padding: EdgeInsets.only(
                    top: 64.0,
                    bottom: 0.0,
                    left: 28.0,
                    right: 28.0,
                  ),
                  child: Icon(Icons.arrow_back),
                )),
            Positioned(
              bottom: 0.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 28.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.title,
                              style: const TextStyle(
                                  fontSize: 24.0,
                                  color: kLightColor,
                                  fontFamily: "ProximaNovaBold",
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(
                            width: 3.0,
                          ),
                          Text(widget.rating.toString(),
                              style: const TextStyle(
                                  fontSize: 17.0,
                                  color: kLightColor,
                                  fontFamily: "ProximaNovaBold",
                                  fontWeight: FontWeight.normal)),
                          const SizedBox(
                            width: 3.0,
                          ),
                          const Icon(Icons.star, color: kRatingColor, size: 17),
                        ]),
                    const SizedBox(
                      height: 12.0,
                    ),
                    SizedBox(
                      width: size.width / 1.1,
                      child: Text(widget.description,
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: kLightColor,
                          )),
                    ),
                    const SizedBox(
                      height: 28.0,
                    ),
                    SizedBox(
                      width: size.width / 1.2,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  "Distance",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: kLightColor,
                                      fontFamily: "ProximaNovaBold",
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  widget.distance.toString(),
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      color: kLightColor,
                                      fontFamily: "ProximaNovaBold",
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  "Altitude",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: kLightColor,
                                      fontFamily: "ProximaNovaBold",
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  widget.altitude,
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      color: kLightColor,
                                      fontFamily: "ProximaNovaBold",
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  "Difficulty",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: kLightColor,
                                      fontFamily: "ProximaNovaBold",
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  widget.difficulty.name,
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      color: kLightColor,
                                      fontFamily: "ProximaNovaBold",
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ]),
                    ),
                    const SizedBox(
                      height: 28.0,
                    ),
                    GestureDetector(
                      onVerticalDragUpdate: (details) {
                        int sensitivity = 8;
                        if (details.delta.dy > sensitivity) {
                          // Down Swipe
                        } else if (details.delta.dy < -sensitivity) {
                          // Up Swipe
                          Navigator.of(context).pop();
                        }
                      },
                      child: Align(
                          alignment: Alignment.center,
                          child: Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              margin: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) {
                                      if (states
                                          .contains(MaterialState.pressed)) {
                                        return Colors.transparent;
                                      }
                                      return Colors.transparent;
                                    }),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0)))),
                                child: Text('Details',
                                    style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ))
                          //SizedBox(
                          //   width: size.width / 1.2,
                          //   child: const Icon(Icons.arrow_upward,
                          //       color: Colors.white),
                          // )
                          ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            )
          ],
        ))));
  }
}
