// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pathfinder_app/controllers/global_controller.dart';
import 'package:pathfinder_app/models/difficulty.dart';
import 'package:pathfinder_app/models/weather_data_daily.dart';
import 'package:pathfinder_app/utils/constant_colors.dart';
import '../models/review.dart';
import '../repositories/trail_respository.dart';
import '../reusable_widgets/daily_weather_widget.dart';
import '../reusable_widgets/reusable_widget.dart';
import '../utils/colors_utils.dart';

class TrailDetailsScreen extends StatefulWidget {
  final int index;
  final String title, description, coverImage, content;
  final double rating, distance, altitude, latitude, longitude;
  final Difficulty difficulty;
  final List<dynamic> images;

  const TrailDetailsScreen({
    super.key,
    required this.index,
    required this.title,
    required this.description,
    required this.content,
    required this.coverImage,
    required this.distance,
    required this.altitude,
    required this.difficulty,
    required this.rating,
    required this.latitude,
    required this.longitude,
    required this.images,
  });

  @override
  _TrailDetailsScreenState createState() => _TrailDetailsScreenState();
}

class _TrailDetailsScreenState extends State<TrailDetailsScreen> {
  final GlobalController _globalController = GlobalController();
  final _reviewTextController = TextEditingController();
  late ScrollController _scrollController;

  final TrailRepository trailRepository = TrailRepository();

  late List<Daily> weatherDataDaily;
  final dates = <Widget>[];
  final currentDate = DateTime.now();
  final _dayFormatter = DateFormat('d');
  final _monthFormatter = DateFormat('MMM');
  late List<Review> trailReviews = [];

  Future<void> init() async {
    trailReviews = await trailRepository.getAllReviews();

    weatherDataDaily = await getWeather(widget.latitude, widget.longitude);

    for (int i = 0; i < weatherDataDaily.length; i = i + 1) {
      final date = currentDate.add(Duration(days: i));

      dates.add(Row(
        children: [
          Text(
            _dayFormatter.format(date),
          ),
          const Text(" "),
          Text(
            _monthFormatter.format(date),
          ),
        ],
      ));
    }

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.offset <=
          _scrollController.position.minScrollExtent) {
        // Scroll to top
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
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
          return buildTrail(context);
        }
      },
    );
  }

  Widget buildTrail(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _scrollController.animateTo(
    //     0,
    //     duration: const Duration(milliseconds: 300),
    //     curve: Curves.easeOut,
    //   );
    // });

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: kLightColor,
        body: SafeArea(
            child: ListView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: false,
                children: [
              SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                    SizedBox(
                      height: size.height * 0.7,
                      child: Stack(children: [
                        PageView.builder(
                            itemCount: widget.images.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(
                                children: [
                                  //logo(widget.images[index].toString()),
                                  Hero(
                                    tag: "trail${widget.index}",
                                    child: Image.asset(
                                      widget.images[index].toString(),
                                      height: size.height,
                                      width: size.width,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                      height: size.height,
                                      width: size.width,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black,
                                          ],
                                          stops: [
                                            0.6,
                                            0.9,
                                          ],
                                        ),
                                      )),
                                ],
                              );
                            }),
                        GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Padding(
                              padding: EdgeInsets.only(
                                top: 30.0,
                                bottom: 0.0,
                                left: 28.0,
                                right: 28.0,
                              ),
                              child: Icon(Icons.arrow_back),
                            )),
                        Positioned(
                          bottom: 0.0,
                          right: 10.0,
                          left: 10.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 28.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Text(widget.title,
                                      style: GoogleFonts.poppins(
                                          fontSize: 28.0,
                                          fontWeight: FontWeight.bold,
                                          color: kLightColor)),
                                  const SizedBox(
                                    width: 3.0,
                                  ),
                                  Text(widget.rating.toString(),
                                      style: GoogleFonts.poppins(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.normal,
                                          color: kLightColor)),
                                  const SizedBox(
                                    width: 3.0,
                                  ),
                                  const Icon(Icons.star,
                                      color: kRatingColor, size: 17),
                                ]),
                                const SizedBox(
                                  height: 12.0,
                                ),
                                SizedBox(
                                  width: size.width / 1.2,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text("Distance",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: kLightColor)),
                                            const SizedBox(
                                              height: 10.0,
                                            ),
                                            Text(
                                                '${widget.distance.round().toString()}km',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: kLightColor)),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text("Altitude",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: kLightColor)),
                                            const SizedBox(
                                              height: 10.0,
                                            ),
                                            Text(
                                                '${widget.altitude.round().toString()}m',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: kLightColor)),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text("Difficulty",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: kLightColor)),
                                            const SizedBox(
                                              height: 10.0,
                                            ),
                                            Text(widget.difficulty.name,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: kLightColor)),
                                          ],
                                        ),
                                      ]),
                                ),
                                const SizedBox(
                                  height: 28.0,
                                ),
                                SizedBox(
                                  height: 100.0,
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: weatherDataDaily.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Stack(children: <Widget>[
                                          DailyWeatherWidget(
                                              index: index,
                                              daily: weatherDataDaily[index],
                                              date: dates[index]),
                                        ]);
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ),
                    // a doua parte
                    Stack(children: [
                      SizedBox(
                        height: size.height,
                        width: size.width,
                        // decoration: const BoxDecoration(
                        //   gradient: LinearGradient(
                        //     begin: Alignment.topCenter,
                        //     end: Alignment.bottomCenter,
                        //     colors: [
                        //       Colors.transparent,
                        //       Colors.black,
                        //     ],
                        //     stops: [
                        //       0.6,
                        //       0.9,
                        //     ],
                        //   ),
                        // ),
                      ),
                      Positioned(
                        top: size.height * 0.0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: hexStringToColor("#ffffff"),
                            borderRadius: const BorderRadius.only(
                                //topLeft: Radius.circular(40),
                                //topRight: Radius.circular(40),
                                ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 15,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.content,
                                  style: GoogleFonts.poppins(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.normal,
                                    color: hexStringToColor("#44564a"),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                reusableTextField(
                                    "Write a review...",
                                    Icons.wrong_location_sharp,
                                    false,
                                    _reviewTextController,
                                    () {}),
                                SizedBox(
                                    height: 100,
                                    child: Expanded(
                                        child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            itemCount: trailReviews.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Stack(children: <Widget>[
                                                Hero(
                                                    tag: "review$index",
                                                    child: Text(
                                                        trailReviews[index]
                                                            .title)),
                                              ]);
                                            })))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ])
                  ]))
            ])));
  }

  Future<List<Daily>> getWeather(double lat, double lon) async {
    List<Daily> dailyWeather =
        await _globalController.getWeatherByLatAndLon(lat, lon);

    return dailyWeather;
  }
}
