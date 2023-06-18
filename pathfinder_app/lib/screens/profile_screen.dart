import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pathfinder_app/repositories/user_repository.dart';
import 'package:pathfinder_app/utils/fonts.dart';
import 'package:pathfinder_app/widgets/custom_nav_bar.dart';
import 'package:pathfinder_app/widgets/reusable_widget.dart';
import '../models/user.dart';
import '../widgets/custom_circular_progress_indicator.dart';

class ProfileScreen extends StatefulWidget {
  final String email;

  ProfileScreen({Key? key, required this.email}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late DocumentReference ref;
  late User user;
  final UserRepository userRepository = UserRepository();
  late File? _selectedImage = null;
  final ImagePicker _imagePicker = ImagePicker();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  bool _isEditing = false;

  Future<void> init() async {
    ref = await userRepository.getUserRefByEmail(widget.email);
    user = await userRepository.getUserByRef(ref);
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

  void _editProfile() {
    setState(() {
      _isEditing = true;
    });
  }

  void _saveProfile() async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String location = _locationController.text;

    await userRepository.updateUser(user.id, username, email, location);

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
          return Text('Failed to initialize event: ${snapshot.error}');
        } else {
          return buildProfile(context);
        }
      },
    );
  }

  Widget buildProfile(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0),
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
                                    as ImageProvider<Object>?
                                : AssetImage(user.profilePhoto),
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
                                Text(user.username, style: normalFont),
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
                                Text(user.email, style: normalFont),
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
                                Text(user.location, style: normalFont),
                              ],
                            ),
                      SizedBox(height: 15.0),
                      _isEditing
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                customButton(context, 'Save', _saveProfile),
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
}
