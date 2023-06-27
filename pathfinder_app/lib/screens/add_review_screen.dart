import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pathfinder_app/repositories/trail_respository.dart';
import '../models/trail.dart';
import '../models/user.dart';
import '../repositories/review_repository.dart';
import '../repositories/user_repository.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../utils/constant_colors.dart';
import '../widgets/reusable_widget.dart';
import '../widgets/star_review_widget.dart';
import 'package:image_picker/image_picker.dart';

class AddReviewScreen extends StatefulWidget {
  final String email;
  final Trail trail;

  const AddReviewScreen({Key? key, required this.trail, required this.email})
      : super(key: key);

  @override
  _AddReviewScreen createState() => _AddReviewScreen();
}

class _AddReviewScreen extends State<AddReviewScreen> {
  final TextEditingController _reviewController = TextEditingController();
  late ScrollController _scrollController;
  final TrailRepository trailRepository = TrailRepository();
  final UserRepository userRepository = UserRepository();
  final ReviewRepository reviewRepository = ReviewRepository();
  late User user;

  late List<String> images = [];
  late List<File> selectedImages = [];
  late double rating;

  Future<void> init() async {
    user = await userRepository.getUserByEmail(widget.email);

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
    //init();
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
      padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
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
            SizedBox(height: 20),
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
            customButton(
              context,
              "Add review",
              () {
                uploadImagesToFirebase();
                reviewRepository.addReview(
                  _reviewController.text,
                  images,
                  rating.toString(),
                  widget.trail.id!,
                  user.id,
                );

                Navigator.of(context).pop(true);
              },
            )
          ],
        ),
      ]),
    ));
  }

  Future<void> _getFromGallery() async {
    List<XFile> pickedFiles = await ImagePicker().pickMultiImage();

    for (var i = 0; i < pickedFiles.length; i++) {
      selectedImages.add(File(pickedFiles[i].path));
    }
    setState(() {
      for (var i = 0; i < selectedImages.length; i++) {
        images.add(selectedImages[i].path);
      }
    });
  }

  Future<void> uploadImagesToFirebase() async {
    for (var i = 0; i < selectedImages.length; i++) {
      File image = selectedImages[i];
      String fileName = image.path.split('/').last;

      try {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('images/$fileName');
        await ref.putFile(image);
        String imageUrl = await ref.getDownloadURL();

        setState(() {
          images[i] = imageUrl;
        });
      } catch (error) {
        print('Failed to upload image: $error');
      }
    }
  }

  void handleRating(double value) {
    rating = value;
  }
}
