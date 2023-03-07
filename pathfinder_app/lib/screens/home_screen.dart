// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pathfinder_app/screens/login_screen.dart';
import '../reusable_widgets/nav_bar.dart';
import '../reusable_widgets/reusable_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: ElevatedButton(
            child: Text("${user?.email!}"),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                print("Sign out");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              });
            },
          ),
        ),
        bottomNavigationBar: const CustomBottomNavBar());
    //bottomNavigationBar: homeNavBar(context));
  }
}
