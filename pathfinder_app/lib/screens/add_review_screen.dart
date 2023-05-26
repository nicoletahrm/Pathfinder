// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pathfinder_app/repositories/trail_respository.dart';
import '../reusable_widgets/reusable_widget.dart';
import '../reusable_widgets/star_review_widget.dart';
import '../utils/colors_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

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
  late List<String> images = [];
  late File _selectedImage;
  late double rating;

  void _uploadPhoto() async {
    try {
      final String downloadUrl = await trailRepository.upload(_selectedImage);
      images.add(downloadUrl);
      print('Image uploaded: $downloadUrl');
    } catch (e) {
      print('Image upload failed: $e');
    }
  }

  _getFromGallery() async {
    final PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        images.add(_selectedImage.path);
        print(images);
        print('Image selected: ${_selectedImage.path}');
      });
    }
  }

  Future<void> saveImageToStorage(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/$images/$imageFile';

    // Create the directory if it doesn't exist
    await Directory('${directory.path}/$images').create(recursive: true);

    // Copy the image file to the desired location
    await imageFile.copy(imagePath);
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
    init();
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.fromLTRB(30, 70, 30, 0),
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
          ElevatedButton(
            onPressed: () {
              _getFromGallery();
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.photo_library),
                SizedBox(width: 8),
                Text('Add Photo'),
              ],
            ),
          ),
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
