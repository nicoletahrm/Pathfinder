// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pathfinder_app/reusable_widgets/reusable_widget.dart';
import '../models/difficulty.dart';
import '../models/trail.dart';
import '../reusable_widgets/custom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _homeTextController = TextEditingController();

  final List<Trail> demoRoutes = [
    Trail(
        id: 1,
        title: "Cabana Malaiesti",
        description:
            "Valea Mălăiești este unul dintre cele mai frumoase, dar și cele mai populare locuri din Munții Bucegi în această perioadă din an. Accesul destul de facil și peisajele minunate, fac ca Valea Mălăiești să fie o destinație des aleasă pe parcursul verii. Sunt mai multe variante de trasee, de la 2-3 ore (ca cel prezentat acum), până la 4-5 (cum ar fi urcarea pe poteca și mai frumoasă – Pichetul Roșu – Take Ionescu), iar odată ajuns în Valea Mălăiești, dacă mai ai energie, poți continua să urci spre Vf. Omu prin Hornurile Mălăiești, sau să te îndrepți spre Brâna Caprelor ori Padina Crucii. Atenție însă că multe dintre zone rămân inaccesibile în condiții de siguranță chiar și în prima parte a verii, din cauza „limbilor” de zăpadă care se topesc mai greu și care pot fi periculoase.",
        coverImage: "assets/images/image2.jpg",
        time: const Duration(hours: 6),
        routeLength: 12,
        difficulty: Difficulty.easy)
  ];

  @override
  Widget build(BuildContext context) {
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
                height: 40.0,
              ),
              Container(
                height: 360.0,
                width: 220.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.0),
                  image: const DecorationImage(
                      image: AssetImage("assets/images/image2.jpg"),
                      fit: BoxFit.cover),
                  // gradient: const LinearGradient(
                  //   begin: Alignment.topCenter,
                  //   end: Alignment.bottomCenter,
                  //   colors: [
                  //     Colors.transparent,
                  //     Colors.black38,
                  //   ],
                  //   stops: [
                  //     0.6,
                  //     0.9,
                  //   ],
                ),
                // child: const Text(
                //   "easy",

                //   style: TextStyle(
                //     fontSize: 18.0,
                //     color: Colors.white,
                //     fontWeight: FontWeight.bold
                //   )
                // ),
              ),
              const Positioned(
                  top: 24.0,
                  left: 24.0,
                  child: Image(
                    image: AssetImage("assets/images/banda_albastra.png"),
                  )),
            ])),
        bottomNavigationBar: const CustomBottomNavBar());
  }
}
