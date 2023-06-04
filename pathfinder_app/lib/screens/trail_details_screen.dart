import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pathfinder_app/controllers/global_controller.dart';
import 'package:pathfinder_app/models/weather_data_daily.dart';
import 'package:pathfinder_app/utils/constant_colors.dart';
import '../models/review.dart';
import '../models/trail.dart';
import '../models/user.dart';
import '../repositories/trail_respository.dart';
import '../widgets/custom_circular_progress_indicator.dart';
import '../widgets/daily_weather_widget.dart';
import '../widgets/favorite_widget.dart';
import '../widgets/review_widget.dart';
import '../utils/colors_utils.dart';
import 'add_review_screen.dart';

class TrailDetailsScreen extends StatefulWidget {
  final int index;
  final String title;

  const TrailDetailsScreen(
      {super.key, required this.index, required this.title});

  @override
  _TrailDetailsScreenState createState() => _TrailDetailsScreenState();
}

class _TrailDetailsScreenState extends State<TrailDetailsScreen> {
  final GlobalController _globalController = GlobalController();
  late ScrollController _scrollController;
  final TrailRepository trailRepository = TrailRepository();
  late List<Daily> weatherDataDaily;
  final dates = <Widget>[];
  final currentDate = DateTime.now();
  final _dayFormatter = DateFormat('d');
  final _monthFormatter = DateFormat('MMM');
  late List<Review> trailReviews = [];
  late User user;
  late Trail? trail;
  late DocumentReference ref;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    trail = await trailRepository.getTrailByTitle(widget.title);
    ref = await trailRepository.getRefTrailByTitle(widget.title);
    weatherDataDaily = await getWeather(trail!.latitude, trail!.longitude);
    trailReviews = await trailRepository.getTrailReviewsByRef(ref);

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
          return buildTrail(context);
        }
      },
    );
  }

  Widget buildTrail(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: kLightColor,
          body: SafeArea(
              child: ListView(
                  controller: _scrollController,
                  shrinkWrap: false,
                  children: [
                Container(
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                        SizedBox(
                          height: size.height * 0.7,
                          child: Stack(children: [
                            PageView.builder(
                                itemCount: trail!.images.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Stack(
                                    children: [
                                      Hero(
                                        tag: "trail${widget.index}",
                                        child: Image.asset(
                                          trail!.images[index].toString(),
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
                                    left: 28.0,
                                    right: 28.0,
                                  ),
                                  child: Icon(Icons.arrow_back),
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                  top: 30.0,
                                  left: size.width - 70,
                                ),
                                child: FavoriteButton(title: widget.title)),
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
                                      Text(trail!.rating.toStringAsPrecision(2),
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: kLightColor)),
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                                Text(
                                                    '${trail!.distance.round().toString()}km',
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: kLightColor)),
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                                Text(
                                                    '${trail!.altitude.round().toString()}m',
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: kLightColor)),
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                                Text(trail!.difficulty.name,
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
                                          physics:
                                              const BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: weatherDataDaily.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Stack(children: <Widget>[
                                              DailyWeatherWidget(
                                                  index: index,
                                                  daily:
                                                      weatherDataDaily[index],
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
                          Container(
                            padding: const EdgeInsets.all(0.0),
                            constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height -
                                  MediaQuery.of(context).padding.top -
                                  MediaQuery.of(context).padding.bottom,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: hexStringToColor("#ffffff"),
                                borderRadius: const BorderRadius.only(),
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
                                padding:
                                    const EdgeInsets.fromLTRB(30, 20, 30, 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      trail!.content,
                                      style: GoogleFonts.poppins(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.normal,
                                        color: hexStringToColor("#44564a"),
                                      ),
                                    ),
                                    const SizedBox(height: 28),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Let's see some reviews",
                                        style: GoogleFonts.poppins(
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                          color: hexStringToColor("#44564a"),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 60,
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 20),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push<bool>(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddReviewScreen(ref: ref),
                                            ),
                                          ).then((result) {
                                            setState(() async {
                                              trail = await trailRepository
                                                  .getTrailByTitle(
                                                      widget.title);
                                            });
                                          });
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.resolveWith(
                                                  (states) {
                                            if (states.contains(
                                                MaterialState.pressed)) {
                                              return Colors.black26;
                                            }
                                            return hexStringToColor("#44564a");
                                          }),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Add review',
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      height: 330,
                                      child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: trailReviews.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ReviewWidget(
                                            content:
                                                trailReviews[index].content,
                                            images: trailReviews[index].images,
                                            ref: trailReviews[index].user,
                                            trailRef: trailReviews[index].trail,
                                            rating: trailReviews[index].rating,
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ])
                      ])),
                )
              ]))),
    );
  }

  Future<List<Daily>> getWeather(double lat, double lon) async {
    List<Daily> dailyWeather =
        await _globalController.getWeatherByLatAndLon(lat, lon);

    return dailyWeather;
  }
}
