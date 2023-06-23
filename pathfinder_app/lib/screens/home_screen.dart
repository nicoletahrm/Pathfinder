import 'package:pathfinder_app/repositories/trail_respository.dart';
import 'package:pathfinder_app/widgets/reusable_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constant_colors.dart';
import '../utils/covert.dart';
import '../utils/fonts.dart';
import '../widgets/custom_nav_bar.dart';
import 'package:flutter/material.dart';
import '../models/trail.dart';
import '../widgets/trails_list_widget.dart';
import 'login_screen.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

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

  static const IconData filter_list =
      IconData(0xe280, fontFamily: 'MaterialIcons');

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
                    SizedBox(width: 10.0),
                    GestureDetector(
                      onTap: () {
                        showDifficultyFilterDialog();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 14.0,
                          horizontal: 16.0,
                        ),
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        child: Icon(
                          filter_list,
                          color: hexStringToColor("#f0f3f1"),
                        ),
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

  void filterTrailsByDifficulty(String difficultyFilter) async {
    setState(() {
      filteredTrails = trails.where((trail) {
        return trail.difficulty == stringToDifficulty(difficultyFilter);
      }).toList();
    });
  }

  void showDifficultyFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Choose a difficulty:", style: darkBoldFont2),
                  ListTile(
                    title: Text('Easy', style: normalFont),
                    onTap: () {
                      selectedDifficulty = 'easy';
                      filterTrailsByDifficulty(selectedDifficulty);
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    title: Text('Mediu', style: normalFont),
                    onTap: () {
                      selectedDifficulty = 'mediu';
                      filterTrailsByDifficulty(selectedDifficulty);
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    title: Text('Hard', style: normalFont),
                    onTap: () {
                      selectedDifficulty = 'hard';
                      filterTrailsByDifficulty(selectedDifficulty);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ));
      },
    );
  }
}
