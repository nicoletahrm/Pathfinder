import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pathfinder_app/repositories/user_repository.dart';
import 'package:pathfinder_app/utils/fonts.dart';
import 'package:pathfinder_app/widgets/custom_nav_bar.dart';
import 'package:pathfinder_app/widgets/reusable_widget.dart';
import '../models/user.dart';
import '../widgets/custom_circular_progress_indicator.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../widgets/custom_dialog.dart';

class ProfileScreen extends StatefulWidget {
  final String email;

  ProfileScreen({Key? key, required this.email}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User user;
  final UserRepository userRepository = UserRepository();
  late File? _selectedImage = null;
  final ImagePicker _imagePicker = ImagePicker();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  bool _isEditing = false;
  late String profilePhoto = '';

  Future<void> init() async {
    user = await userRepository.getUserByEmail(widget.email);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> uploadImageToFirebase() async {
    String path = _selectedImage!.path;
    profilePhoto = path;

    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref().child('/images/$fileName');
      await ref.putFile(_selectedImage!);
    } catch (error) {
      print('Failed to upload image: $error');
    }
  }

  void _editProfile() {
    setState(() {
      _isEditing = true;
    });
  }

  void _saveProfile() async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String location = _locationController.text;

    uploadImageToFirebase();
    profilePhoto = _selectedImage!.path;

    await userRepository.updateUser(
        user.id, username, email, location, profilePhoto);

    setState(() {
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile updated successfully!'),
      ),
    );
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
    });
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
          return Text('Failed to initialize profile: ${snapshot.error}');
        } else {
          return buildProfile(context);
        }
      },
    );
  }

  Widget buildProfile(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height / 6),
                  Center(
                    child: GestureDetector(
                      onTap: _isEditing ? _pickImage : null,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.transparent,
                            backgroundImage: _selectedImage != null
                                ? FileImage(_selectedImage!)
                                : FileImage(File(user.profilePhoto)),
                          ),
                          if (_isEditing)
                            Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.photo_camera,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40.0),
                  Column(
                    children: [
                      _isEditing
                          ? reusableNormalTextField(
                              'Username',
                              Icons.person_outline,
                              _usernameController,
                              _isEditing, () {
                              _usernameController.text = user.username;
                            })
                          : Column(
                              children: [
                                Text("Username:", style: darkBoldFont),
                                Text(user.username, style: darkNormalFont),
                              ],
                            ),
                      SizedBox(height: 15.0),
                      _isEditing
                          ? reusableNormalTextField('Email:', Icons.mail,
                              _emailController, _isEditing, () {
                              _emailController.text = user.email;
                            })
                          : Column(
                              children: [
                                Text("Email:", style: darkBoldFont),
                                Text(user.email, style: darkNormalFont),
                              ],
                            ),
                      SizedBox(height: 15.0),
                      _isEditing
                          ? reusableNormalTextField(
                              'Location:',
                              Icons.location_city,
                              _locationController,
                              _isEditing, () {
                              _locationController.text = user.location;
                            })
                          : Column(
                              children: [
                                Text("Location:", style: darkBoldFont),
                                Text(user.location, style: darkNormalFont),
                              ],
                            ),
                      SizedBox(height: 15.0),
                      _isEditing
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                customButton(context, 'Save', validation),
                                customButton(context, 'Cancel', _cancelEditing),
                              ],
                            )
                          : customButton(context, 'Edit', _editProfile),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar());
  }

  void validation() async {
    if (_usernameController.text.isEmpty || _emailController.text.isEmpty) {
      CustomDialog.show(
        context,
        "Empty fields",
        "Please fill in required fields.",
      );
    } else {
      _saveProfile();
    }
  }
}
