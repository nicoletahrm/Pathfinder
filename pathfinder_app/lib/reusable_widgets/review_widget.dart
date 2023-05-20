// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors_utils.dart';

class ReviewWidget extends StatefulWidget {
  final String content;

  const ReviewWidget({Key? key, required this.content}) : super(key: key);

  @override
  _ReviewWidgetState createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: [
          Container(
            height: 90.0,
            width: double.infinity,
            alignment: Alignment.center,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                widget.content,
                style: GoogleFonts.poppins(
                  fontSize: 18.0,
                  fontWeight: FontWeight.normal,
                  color: hexStringToColor("#44564a"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
