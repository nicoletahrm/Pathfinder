// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:pathfinder_app/screens/profile/profile_picture.dart';
import '../../reusable_widgets/reusable_widget.dart';
import '../../utils/colors_utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Stack(children: [
          const ProfilePicture(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                padding: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                backgroundColor: hexStringToColor('FFF5F6F9'),
              ),
              onPressed: () {},
              child: Row(
                children: [
                  logo("assets/images/logo1.png"),
                  const SizedBox(width: 20),
                  const Text("My account"),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          )
        ])
      ])
    ]));
  }
}
