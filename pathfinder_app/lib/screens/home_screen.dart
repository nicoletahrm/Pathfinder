import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pathfinder_app/repositories/trail_respository.dart';
import 'package:pathfinder_app/reusable_widgets/reusable_widget.dart';
import 'package:pathfinder_app/screens/trail_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/difficulty.dart';
import '../models/trail.dart';
import '../reusable_widgets/custom_nav_bar.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../utils/constant_colors.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _homeTextController = TextEditingController();

  TrailRepository trailRepository = TrailRepository();
  late Future<List<Trail?>> trailsList;
  late List<Trail?> trails;

  List<Trail> demoRoutes = [
    Trail(
      title: "Cabana Malaiesti",
      description: "Valea Glăjăriei - Cabana Malaiesti",
      coverImage: "assets/images/image2.jpg",
      //time: const Duration(hours: 6),
      //routeLength: 12,
      difficulty: Difficulty.easy,
      //altitude: 1720,
      // rating: 4.9
    ),
    Trail(
      title: "Vf. Omu",
      description: "Padina - Vf. Omu",
      coverImage: "assets/images/image2.jpg",
      //time: const Duration(hours: 9),
      //routeLength: 20,
      difficulty: Difficulty.hard,
      // altitude: 1820,
      // rating: 4.0
    ),
    Trail(
      title: "Vf. Piatra Mica",
      description:
          "Fantana lui Botorog - Poiana Zanoaga - Cabana Curmatura - Vf. Piara Mica",
      coverImage: "assets/images/image3.jpg",
      //time: const Duration(hours: 9),
      //routeLength: 20,
      difficulty: Difficulty.easy,
      //altitude: 1720,
      //rating: 4.0
    ),
    Trail(
      title: "Vf. Ascutit",
      description:
          "Fantana lui Botorog - Poiana Zanoaga - Cabana Curmatura - Vf. Ascultit",
      coverImage: "assets/images/image2.jpg",
      //time: const Duration(hours: 9),
      //routeLength: 20,
      difficulty: Difficulty.easy,
      //altitude: 1720,
      // rating: 4.0
    ),
    Trail(
      title: "Vf. Piatra Mare",
      description: "7 scari - Vf. Piara Mare",
      coverImage: "assets/images/image3.jpg",
      //time: const Duration(hours: 9),
      //routeLength: 20,
      difficulty: Difficulty.easy,
      //altitude: 1720,
      //rating: 4.0
    )
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Future<void> init() async {
      trailsList = trailRepository.getAllTrails();
      trails = await trailRepository.getAllTrails();
    }

    init();

    return Scaffold(
        backgroundColor: kDefaultIconLightColor,
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.only(
                  top: 80.0, bottom: 0.0, left: 20.0, right: 20.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "It's time for another hike!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: "ProximaNovaBold",
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout_outlined),
                        onPressed: () async {
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          pref.remove("email");
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) {
                            return const LoginScreen();
                          }));
                        },
                      ),
                    ]),
                const SizedBox(
                  height: 30.0,
                ),
                reusableTextField("Search a place...", Icons.search_outlined,
                    false, _homeTextController, (() {})),
                const SizedBox(
                  height: 30.0,
                ),
                SizedBox(
                  height: 590.0,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: trails.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                            onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => TrailDetailsScreen(
                                        index: index,
                                        title: trails[index]!.title,
                                        description: trails[index]!.description,
                                        coverImage: trails[index]!.coverImage,
                                        difficulty: trails[index]!.difficulty,
                                        rating: trails[index]!.rating),
                                  ),
                                ),
                            child: (Stack(children: <Widget>[
                              Hero(
                                tag: "trail$index",
                                child: Container(
                                    height: 160.0,
                                    width: 700.0,
                                    margin: const EdgeInsets.only(top: 20.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14.0),
                                      image: DecorationImage(
                                          image: AssetImage(
                                              trails[index]!.coverImage),
                                          fit: BoxFit.cover),
                                    )),
                              ),
                              Container(
                                  height: 160.0,
                                  width: 700.0,
                                  margin: const EdgeInsets.only(top: 24.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14.0),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black87,
                                      ],
                                      stops: [
                                        0.6,
                                        0.9,
                                      ],
                                    ),
                                  )),
                              Positioned(
                                bottom: 24.0,
                                right: 24.0,
                                child: GlassmorphicContainer(
                                    height: 32.0,
                                    width: 75.0,
                                    blur: 2.0,
                                    border: 0.0,
                                    borderRadius: 8.0,
                                    alignment: Alignment.center,
                                    linearGradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        kLightColor.withOpacity(0.4),
                                        kLightColor.withOpacity(0.4),
                                      ],
                                    ),
                                    borderGradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        kLightColor.withOpacity(0.4),
                                        kLightColor.withOpacity(0.4),
                                      ],
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                          trails[index]!.difficulty.name,
                                          style: const TextStyle(
                                              fontSize: 18.0,
                                              color: kLightColor,
                                              fontWeight: FontWeight.bold)),
                                    )),
                              ),
                              Positioned(
                                bottom: 25.0,
                                left: 24.0,
                                width: size.width / 2.6,
                                child: Text(trails[index]!.title,
                                    style: const TextStyle(
                                        fontSize: 24.0,
                                        color: kLightColor,
                                        fontFamily: "ProximaNovaBold",
                                        fontWeight: FontWeight.bold)),
                              ),
                            ])));
                      }),
                )
              ])),
        ),
        bottomNavigationBar: const CustomBottomNavBar());
  }
}
