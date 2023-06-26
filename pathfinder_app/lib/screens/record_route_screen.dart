import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pathfinder_app/repositories/request_repository.dart';
import 'package:pathfinder_app/repositories/user_repository.dart';
import 'package:pathfinder_app/screens/home_screen.dart';
import 'package:pathfinder_app/widgets/custom_nav_bar.dart';
import 'package:pathfinder_app/widgets/reusable_widget.dart';
import '../models/user.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../widgets/custom_circular_progress_indicator.dart';
import 'draw_route.dart';

class RecordRouteScreen extends StatefulWidget {
  final String email, fileName;
  final List<LatLng> list;

  RecordRouteScreen(
      {Key? key,
      required this.email,
      required this.fileName,
      required this.list})
      : super(key: key);

  @override
  _RecordRouteScreenState createState() => _RecordRouteScreenState();
}

class _RecordRouteScreenState extends State<RecordRouteScreen> {
  late DocumentReference ref;
  late User user;
  final UserRepository userRepository = UserRepository();
  final RequestRepository requestRepository = RequestRepository();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _sourceController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  TextEditingController _signController = TextEditingController();
  TextEditingController _altitudeController = TextEditingController();
  TextEditingController _distanceController = TextEditingController();

  late ScrollController _scrollController;
  List<File> selectedImages = [];
  late List<String> images = [];

  Future<void> init() async {
    ref = await userRepository.getUserRefByEmail(widget.email);
    user = await userRepository.getUserByRef(ref);

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
  void dispose() {
    _titleController.dispose();
    _sourceController.dispose();
    _destinationController.dispose();
    _signController.dispose();
    _altitudeController.dispose();
    _distanceController.dispose();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
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
              CustomCircularProgressIndicator(),
            ],
          ));
        } else if (snapshot.hasError) {
          return Text('Failed to initialize screen: ${snapshot.error}');
        } else {
          return buildScreen(context);
        }
      },
    );
  }

  Widget buildScreen(BuildContext context) {
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
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 70.0,
                      ),
                      Text(
                        "Request a new trail",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: "ProximaNovaBold",
                        ),
                      ),
                      SizedBox(
                        height: 60.0,
                      ),
                      reusableNormalTextField(
                          'Name', Icons.hiking, _titleController, true, () {}),
                      SizedBox(height: 15.0),
                      reusableNormalTextField('Start location',
                          Icons.location_pin, _sourceController, true, () {}),
                      SizedBox(height: 15.0),
                      reusableNormalTextField('Sign', Icons.icecream_outlined,
                          _signController, true, () {}),
                      SizedBox(height: 15.0),
                      reusableNormalTextField('Altitude', Icons.alt_route,
                          _altitudeController, true, () {}),
                      SizedBox(height: 15.0),
                      reusableNormalTextField('Distance', Icons.gas_meter,
                          _distanceController, true, () {}),
                      SizedBox(height: 15.0),
                      Text(widget.fileName),
                      normalButton(context, 'See trail on map', () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DrawMapScreen(list: widget.list)));
                      }),
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
                      SizedBox(height: 30.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          normalButton(context, 'Request', () async {
                            await uploadImagesToFirebase();
                            await requestRepository.addRequest(
                                _titleController.text,
                                _sourceController.text,
                                _signController.text,
                                widget.fileName,
                                _altitudeController.text,
                                _distanceController.text,
                                images);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Request has been send successfully!'),
                              ),
                            );
                          }),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar());
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
}
