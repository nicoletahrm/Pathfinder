import 'package:flutter/material.dart';
import 'package:pathfinder_app/models/difficulty.dart';
import 'package:pathfinder_app/utils/constant_colors.dart';

class TrailDetailsScreen extends StatefulWidget {
  final int index;
  final String title, description, coverImage;
  final Difficulty difficulty;

  const TrailDetailsScreen(
      {super.key,
      required this.index,
      required this.title,
      required this.description,
      required this.coverImage,
      required this.difficulty});

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
            Positioned(
              bottom: 0.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 28.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title,
                        style: const TextStyle(
                            fontSize: 24.0,
                            color: kLightColor,
                            fontFamily: "ProximaNovaBold",
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      children:
                          //alignment: Alignment.center,
                          List.generate(
                        5,
                        (index) => const Icon(Icons.star, color: kRatingColor),
                      ),
                    ),
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
                  ],
                ),
              ),
            )
          ],
        ))));
  }
}
