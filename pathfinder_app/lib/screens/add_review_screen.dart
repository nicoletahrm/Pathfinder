import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pathfinder_app/repositories/trail_respository.dart';
import '../repositories/review_repository.dart';
import '../repositories/user_repository.dart';
import '../storage/firebase_storage.dart';
import '../utils/constant_colors.dart';
import '../utils/covert.dart';
import '../widgets/reusable_widget.dart';
import '../widgets/star_review_widget.dart';
import 'package:image_picker/image_picker.dart';

class AddReviewScreen extends StatefulWidget {
  final DocumentReference<Object?>? ref;

  const AddReviewScreen({Key? key, required this.ref}) : super(key: key);

  @override
  _AddReviewScreen createState() => _AddReviewScreen();
}

class _AddReviewScreen extends State<AddReviewScreen> {
  final TextEditingController _reviewController = TextEditingController();
  late ScrollController _scrollController;
  final user = FirebaseAuth.instance.currentUser;
  final TrailRepository trailRepository = TrailRepository();
  final UserRepository userRepository = UserRepository();
  final ReviewRepository reviewRepository = ReviewRepository();
  late DocumentReference userRef;
  late List<String> images = [];
  late List<File> _selectedImages;
  late double rating;

  Future<void> init() async {
    userRef = await userRepository.getUserRefByEmail(user?.email);

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.offset <=
          _scrollController.position.minScrollExtent) {
        _scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    userRepository.getUserRefByEmail(user?.email);
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
    Size size = MediaQuery.of(context).size;
    List<Widget> gridItems = [];

    for (String imagePath in images) {
      gridItems.add(
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: Image.file(File(imagePath)),
                );
              },
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: FileImage(File(imagePath)),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    }

    gridItems.add(
      GestureDetector(
        onTap: () {
          _getFromGallery();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.withOpacity(0.5),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.photo_library),
                SizedBox(height: 8),
                Text('Add Photo'),
              ],
            ),
          ),
        ),
      ),
    );

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
      child:
          ListView(controller: _scrollController, shrinkWrap: false, children: [
        Align(
          alignment: Alignment.topLeft,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back),
          ),
        ),
        Column(
          children: [
            StarReviewWidget(onRatingNeeded: handleRating),
            const SizedBox(height: 20),
            textField(
              "What you want to write?",
              _reviewController,
              (() {}),
            ),
            SizedBox(height: 18),
            SingleChildScrollView(
              child: SizedBox(
                height: size.height / 1.6,
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: gridItems,
                ),
              ),
            ),
            SizedBox(height: 18),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
              child: ElevatedButton(
                onPressed: () {
                  _uploadPhotos();
                  reviewRepository.addReview(
                    _reviewController.text,
                    images,
                    rating.toString(),
                    widget.ref,
                    userRef,
                  );
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.black26;
                      }
                      return hexStringToColor("#44564a");
                    },
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                child: Text(
                  'Add review',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ]),
    ));
  }

  void _uploadPhotos() async {
    for (var i = 0; i < _selectedImages.length; i++) {
      try {
        final String downloadUrl =
            await upload(_selectedImages[i]);

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
}
