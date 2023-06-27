import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/review.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';
import '../utils/constant_colors.dart';
import '../utils/covert.dart';
import 'custom_dialog.dart';
import 'images_widget.dart';

class ReviewWidget extends StatefulWidget {
  final Review review;
  final String email;

  const ReviewWidget({Key? key, required this.review, required this.email})
      : super(key: key);

  @override
  _ReviewWidgetState createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  final UserRepository userRepository = UserRepository();
  late User user;
  late User currentUser;

  Future<void> init() async {
    user = await userRepository.getUserById(widget.review.user);
    currentUser = await userRepository.getUserByEmail(widget.email);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Failed to initialize review: ${snapshot.error}');
        } else {
          return buildReview(context);
        }
      },
    );
  }

  Widget buildReview(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.review.images.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ImageSliderScreen(images: widget.review.images),
            ),
          );
        } else {
          CustomDialog.show(context, "No Images", "No images available.");
        }
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
        width: 500,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: FileImage(File(user.profilePhoto)),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        user.username,
                        style: GoogleFonts.poppins(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: hexStringToColor("#44564a"),
                        ),
                      ),
                      SizedBox(width: 3.0),
                      Text(
                        widget.review.rating.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 15.0,
                          fontWeight: FontWeight.normal,
                          color: kDefaultIconDarkColor,
                        ),
                      ),
                      SizedBox(width: 3.0),
                      Icon(Icons.star, color: kRatingColor, size: 17),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        widget.review.content,
                        style: GoogleFonts.poppins(
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                          color: kDefaultIconDarkColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
