// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pathfinder_app/repositories/trail_respository.dart';
import '../models/trail.dart';
import '../widgets/custom_nav_bar.dart';
import '../utils/constant_colors.dart';
import '../widgets/trails_list_widget.dart';

class FavoriteTrailsScreen extends StatefulWidget {
  const FavoriteTrailsScreen({Key? key}) : super(key: key);

  @override
  _FavoriteTrailsScreenState createState() => _FavoriteTrailsScreenState();
}

class _FavoriteTrailsScreenState extends State<FavoriteTrailsScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final TrailRepository _trailRepository = TrailRepository();
  late List<String>? favoriteTrails;
  late List<Trail> trails = [];

  Future<void> init() async {
    favoriteTrails = await _trailRepository.getFavoriteTrails(user!.email);

    for (int i = 0; i < favoriteTrails!.length; i++) {
      Trail? trail = await _trailRepository.getTrailByTitle(favoriteTrails![i]);

      print(trail!.title);
      trails.add(trail);
    }

    print(trails);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for the initialization to complete.
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
          // Show an error message if the initialization failed.
          return Text('Failed to initialize trails: ${snapshot.error}');
        } else {
          // Build the UI with the initialized trails list.
          return buildTrailsList(context);
        }
      },
    );
  }

  Widget buildTrailsList(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: kDefaultIconLightColor,
          body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.only(
                    top: 80.0, bottom: 0.0, left: 20.0, right: 20.0),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Your favorite trails",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: "ProximaNovaBold",
                          ),
                        ),
                      ]),
                  const SizedBox(
                    height: 30.0,
                  ),
                  TrailsList(trails: trails),
                ])),
          ),
          bottomNavigationBar: const CustomBottomNavBar()),
    );
  }
}