import 'package:pathfinder_app/repositories/trail_respository.dart';
import 'package:pathfinder_app/widgets/reusable_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_nav_bar.dart';
import 'package:flutter/material.dart';
import '../models/trail.dart';
import '../widgets/trails_list_widget.dart';
import 'login_screen.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchTextController = TextEditingController();
  final TrailRepository trailRepository = TrailRepository();
  late List<Trail> trails = [];
  late List<Trail> filteredTrails = [];
  late String query;
  String selectedDifficulty = '';

  Future<void> init() async {
    List<Trail> allTrails = await trailRepository.getAllTrails();
    setState(() {
      trails = allTrails;
      filteredTrails = allTrails;
      query = '';
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: kDefaultIconLightColor,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(
              top: 80.0,
              bottom: 0.0,
              left: 20.0,
              right: 20.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                    IconButton(
                      icon: Icon(Icons.logout_outlined),
                      onPressed: () async {
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        pref.remove("email");
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) {
                            return const LoginScreen();
                          }),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 30.0),
                Row(
                  children: [
                    Expanded(
                      child: reusableNormalTextField(
                        "Search a place...",
                        Icons.search_outlined,
                        _searchTextController,
                        true,
                        () {
                          searchTrailByTitle(_searchTextController.text);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25.0),
                TrailsList(trails: filteredTrails),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(),
      ),
    );
  }

  void searchTrailByTitle(String query) {
    setState(() {
      filteredTrails = trails.where((trail) {
        final trailTitle = trail.title.toLowerCase();
        final input = query.toLowerCase();
        return trailTitle.contains(input);
      }).toList();
    });
  }
}
