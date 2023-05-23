// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user.dart';
import '../repositories/trail_respository.dart';
import '../utils/colors_utils.dart';
import '../utils/constant_colors.dart';

class ReviewWidget extends StatefulWidget {
  final String content;
  final double rating;
  final DocumentReference<Object?>? ref;
  final DocumentReference<Object?>? trailRef;

  const ReviewWidget(
      {Key? key,
      required this.content,
      required this.rating,
      required this.ref,
      required this.trailRef})
      : super(key: key);

  @override
  _ReviewWidgetState createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  final TrailRepository trailRepository = TrailRepository();
  late User user;

  Future<void> init() async {
    user = (await trailRepository.getUserByRef(widget.ref))!;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.hasError) {
          return Text('Failed to initialize review: ${snapshot.error}');
        } else {
          return buildReview(context);
        }
      },
    );
  }

  Widget buildReview(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(user.profilePhoto),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(
                    user.username,
                    style: GoogleFonts.poppins(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: hexStringToColor("#44564a"),
                    ),
                  ),
                  const SizedBox(
                    width: 3.0,
                  ),
                  Text(widget.rating.toString(),
                      style: GoogleFonts.poppins(
                          fontSize: 15.0,
                          fontWeight: FontWeight.normal,
                          color: kDefaultIconDarkColor)),
                  const SizedBox(
                    width: 3.0,
                  ),
                  const Icon(Icons.star, color: kRatingColor, size: 17),
                ]),
                Text(widget.content,
                    style: GoogleFonts.poppins(
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        color: kDefaultIconDarkColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
