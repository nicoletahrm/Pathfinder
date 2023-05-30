// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pathfinder_app/repositories/trail_respository.dart';
import 'package:pathfinder_app/widgets/reusable_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/trail.dart';
import '../widgets/custom_circular_progress_indicator.dart';
import '../widgets/custom_nav_bar.dart';
import '../widgets/trails_list_widget.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _searchTextController = TextEditingController();
  final TrailRepository trailRepository = TrailRepository();
  late List<Trail> trails = [];
  late List<Trail> filteredTrails = [];
  late String query;

  Future<void> init() async {
    filteredTrails = await trailRepository.getAllTrails();
    trails = filteredTrails;
    query = '';
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
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CustomCircularProgressIndicator(),
            ],
          ));
        } else if (snapshot.hasError) {
          return Text('Failed to initialize trails: ${snapshot.error}');
        } else {
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
                      false, _searchTextController, () {
                    searchTrailByTitle(_searchTextController.text);
                  }),
                  const SizedBox(
                    height: 25.0,
                  ),
                  TrailsList(trails: trails),
                ])),
          ),
          bottomNavigationBar: const CustomBottomNavBar()),
    );
  }

  dynamic searchTrailByTitle(String query) async {
    setState(() {
      trails = filteredTrails.where((trail) {
        final trailTitle = trail.title.toLowerCase();
        final input = query.toLowerCase();

        return trailTitle.contains(input);
      }).toList();
    });
  }
}
