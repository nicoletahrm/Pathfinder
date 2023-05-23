// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pathfinder_app/repositories/trail_respository.dart';
import '../reusable_widgets/reusable_widget.dart';
import '../reusable_widgets/star_review_widget.dart';
import '../utils/colors_utils.dart';
import '../utils/constant_colors.dart';

class AddReviewScreen extends StatefulWidget {
  final DocumentReference<Object?>? ref;

  const AddReviewScreen({Key? key, required this.ref}) : super(key: key);

  @override
  _AddReviewScreen createState() => _AddReviewScreen();
}

class _AddReviewScreen extends State<AddReviewScreen> {
  final TextEditingController _reviewController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  final TrailRepository trailRepository = TrailRepository();
  late DocumentReference userRef;

  Future<void> init() async {
    userRef = await trailRepository.getUserRefByEmail(user?.email);
  }

  @override
  void initState() {
    super.initState();
    trailRepository.getUserRefByEmail(user?.email);
    init();
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.fromLTRB(30, 70, 30, 0),
      child: Column(
        children: [
          StarReviewWidget(),
          const SizedBox(
            height: 20,
          ),
          textField("What you want to write?", _reviewController, (() {})),
          const SizedBox(
            height: 18,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
            child: ElevatedButton(
              onPressed: () {
                trailRepository.addReview(_reviewController.text,
                    _ratingController.text, widget.ref, userRef);
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.black26;
                    }
                    return hexStringToColor("#44564a");
                  }),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)))),
              child: Text('Add review',
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    ));
  }
}
