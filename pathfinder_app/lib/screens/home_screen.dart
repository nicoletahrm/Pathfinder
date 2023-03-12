// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pathfinder_app/reusable_widgets/reusable_widget.dart';
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
                height: 40.0,
              ),
              Stack(children: [
                Container(
                    height: 500.0,
                    width: 500.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.0),
                      image: const DecorationImage(
                          image: AssetImage("assets/images/image2.jpg"),
                          fit: BoxFit.cover),
                    )),
                Container(
                    height: 500.0,
                    width: 500.0,
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
                  bottom: 40.0,
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
                          //Colors.black12,
                          //Colors.black12,

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
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text("easy",
                            style: TextStyle(
                                fontSize: 18.0,
                                color: kLightColor,
                                fontWeight: FontWeight.bold)),
                      )),
                ),
                Positioned(
                  bottom: 40.0,
                  left: 24.0,
                  width: size.width / 2.6,
                  child: const Text("Cabana Malaiesti",
                      style: TextStyle(
                          fontSize: 28.0,
                          color: Colors.white,
                          fontFamily: "ProximaNovaBold",
                          fontWeight: FontWeight.bold)),
                ),
              ])
            ])),
        bottomNavigationBar: const CustomBottomNavBar());
  }
}
