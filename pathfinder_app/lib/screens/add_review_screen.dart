// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, deprecated_member_use
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pathfinder_app/repositories/trail_respository.dart';
import '../utils/constant_colors.dart';
import '../widgets/reusable_widget.dart';
import '../widgets/star_review_widget.dart';
import '../utils/colors_utils.dart';
import 'package:image_picker/image_picker.dart';

class AddReviewScreen extends StatefulWidget {
  final DocumentReference<Object?>? ref;

  const AddReviewScreen({Key? key, required this.ref}) : super(key: key);

  @override
  _AddReviewScreen createState() => _AddReviewScreen();
}

class _AddReviewScreen extends State<AddReviewScreen> {
  final TextEditingController _reviewController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  final TrailRepository trailRepository = TrailRepository();
  late DocumentReference userRef;
  late List<String> images = [];
  late List<File> _selectedImages;
  late double rating;

  void _uploadPhoto() async {
    for (var i = 0; i < _selectedImages.length; i++) {
      try {
        final String downloadUrl =
            await trailRepository.upload(_selectedImages[i]);

        print('Image uploaded: $downloadUrl');
      } catch (e) {
        print('Image upload failed: $e');
      }
    }
  }

  Future<void> _getFromGallery() async {
    List<XFile> pickedFiles = await ImagePicker().pickMultiImage();
    List<File> selectedImages = [];
    for (var i = 0; i < pickedFiles.length; i++) {
      selectedImages.add(File(pickedFiles[i].path));
    }
    setState(() {
      for (var i = 0; i < selectedImages.length; i++) {
        images.add(selectedImages[i].path);
      }
    });
  }

  void handleRating(double value) {
    rating = value;
  }

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
          return Text('Failed to initialize trails: ${snapshot.error}');
        } else {
          return buildTrail(context);
        }
      },
    );
  }

  Widget buildTrail(BuildContext context) {
    //init();
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.fromLTRB(30, 60, 30, 0),
      child: Stack(children: [
        Align(
          alignment: Alignment.topLeft,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              StarReviewWidget(onRatingNeeded: handleRating),
              const SizedBox(
                height: 20,
              ),
              textField("What you want to write?", _reviewController, (() {})),
              const SizedBox(
                height: 18,
              ),
              Container(
                  width: MediaQuery.of(context).size.width / 3.0,
                  height: 60,
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                  child: ElevatedButton(
                    onPressed: () {
                      _getFromGallery();
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.black26;
                          }
                          return hexStringToColor("#44564a");
                        }),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.photo_library),
                        SizedBox(width: 8),
                        Text('Add Photo'),
                      ],
                    ),
                  )),
              //grid cu pozele adaugate (maxim 4 poze)
              Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                child: ElevatedButton(
                  onPressed: () {
                    _uploadPhoto();
                    trailRepository.addReview(_reviewController.text, images,
                        rating.toString(), widget.ref, userRef);
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
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
        )
      ]),
    ));
  }
}
