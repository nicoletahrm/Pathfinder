// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pathfinder_app/reusable_widgets/reusable_widget.dart';
import '../models/difficulty.dart';
import '../models/trail.dart';
import '../reusable_widgets/custom_nav_bar.dart';
import 'package:glassmorphism/glassmorphism.dart';

import '../utils/constant_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _homeTextController = TextEditingController();

  List<Trail> demoRoutes = [
    Trail(
        id: 0,
        title: "Cabana Malaiesti",
        description:
            "Valea Mălăiești este unul dintre cele mai frumoase, dar și cele mai populare locuri din Munții Bucegi în această perioadă din an. Accesul destul de facil și peisajele minunate, fac ca Valea Mălăiești să fie o destinație des aleasă pe parcursul verii. Sunt mai multe variante de trasee, de la 2-3 ore (ca cel prezentat acum), până la 4-5 (cum ar fi urcarea pe poteca și mai frumoasă – Pichetul Roșu – Take Ionescu), iar odată ajuns în Valea Mălăiești, dacă mai ai energie, poți continua să urci spre Vf. Omu prin Hornurile Mălăiești, sau să te îndrepți spre Brâna Caprelor ori Padina Crucii. Atenție însă că multe dintre zone rămân inaccesibile în condiții de siguranță chiar și în prima parte a verii, din cauza „limbilor” de zăpadă care se topesc mai greu și care pot fi periculoase.",
        coverImage: "assets/images/image2.jpg",
        time: const Duration(hours: 6),
        routeLength: 12,
        difficulty: Difficulty.easy),
    Trail(
        id: 1,
        title: "Vf. Omu",
        description: "Vf. Omu blablabla",
        coverImage: "assets/images/image2.jpg",
        time: const Duration(hours: 9),
        routeLength: 20,
        difficulty: Difficulty.mediu),
    Trail(
        id: 2,
        title: "Vf. Piatra Mica",
        description: "Vf. Piara Mica blablabla",
        coverImage: "assets/images/image3.jpg",
        time: const Duration(hours: 9),
        routeLength: 20,
        difficulty: Difficulty.easy),
    Trail(
        id: 3,
        title: "Vf. Ascutit",
        description: "Vf. Piara Mica blablabla",
        coverImage: "assets/images/image2.jpg",
        time: const Duration(hours: 9),
        routeLength: 20,
        difficulty: Difficulty.easy),
    Trail(
        id: 4,
        title: "Vf. Piatra Mare",
        description: "Vf. Piara Mica blablabla",
        coverImage: "assets/images/image3.jpg",
        time: const Duration(hours: 9),
        routeLength: 20,
        difficulty: Difficulty.easy)
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: kDefaultIconLightColor,
        body: Container(
            padding: const EdgeInsets.only(
                top: 64.0, bottom: 0.0, left: 32.0, right: 32.0),
            child: Column(children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "It's time for another hike!",
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
              reusableTextField("Search a place...", Icons.search_outlined,
                  false, _homeTextController, (() {})),
              const SizedBox(
                height: 10.0,
              ),
              SizedBox(
                height: 590.0,
                //width: 900.0,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: demoRoutes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Stack(children: <Widget>[
                        Container(
                            height: 160.0,
                            width: 700.0,
                            margin: const EdgeInsets.only(top: 20.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14.0),
                              // boxShadow: const [
                              //   BoxShadow(
                              //     color: Colors.black,
                              //     offset: Offset(
                              //       1.0,
                              //       1.0,
                              //     ),
                              //     blurRadius: 10.0,
                              //     spreadRadius: 1.0,
                              //   ),
                              // ],
                              image: DecorationImage(
                                  image:
                                      AssetImage(demoRoutes[index].coverImage),
                                  fit: BoxFit.cover),
                            )),
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
                                child: Text(demoRoutes[index].difficulty.name,
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
                          child: Text(demoRoutes[index].title,
                              style: const TextStyle(
                                  fontSize: 24.0,
                                  color: kLightColor,
                                  fontFamily: "ProximaNovaBold",
                                  fontWeight: FontWeight.bold)),
                        ),
                      ]);
                    }),
              )
            ])),
        bottomNavigationBar: const CustomBottomNavBar());
  }
}
