import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pathfinder_app/models/weather_data_daily.dart';
import 'package:pathfinder_app/utils/constant_colors.dart';
import '../controllers/weather_controller.dart';
import '../models/review.dart';
import '../models/trail.dart';
import '../repositories/review_repository.dart';
import '../repositories/trail_respository.dart';
import '../utils/covert.dart';
import '../widgets/custom_circular_progress_indicator.dart';
import '../widgets/daily_weather_widget.dart';
import '../widgets/reusable_widget.dart';
import '../widgets/review_widget.dart';
import '../widgets/route_widget.dart';
import 'package:connectivity/connectivity.dart';
import '../utils/fonts.dart';
import 'add_review_screen.dart';
import 'map_screen.dart';
import 'package:path/path.dart' as path;

class TrailDetailScreen extends StatefulWidget {
  final Trail trail;
  final String heroTag;

  TrailDetailScreen({Key? key, required this.trail, required this.heroTag})
      : super(key: key);

  @override
  _TrailDetailScreenState createState() => _TrailDetailScreenState();
}

class _TrailDetailScreenState extends State<TrailDetailScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final WeatherController _weatherController = WeatherController();
  late ScrollController _scrollController;
  final TrailRepository trailRepository = TrailRepository();
  final ReviewRepository reviewRepository = ReviewRepository();
  late List<Daily>? weatherDataDaily;
  final dates = <Widget>[];
  final currentDate = DateTime.now();
  final _dayFormatter = DateFormat('d');
  final _monthFormatter = DateFormat('MMM');
  late List<Review> trailReviews = [];
  late bool isConnected;

  Future<void> init() async {
    _scrollController = ScrollController();
    isConnected = await checkInternetConnectivity();

    if (isConnected == true) {
      weatherDataDaily = await await _weatherController.getWeatherData(
          widget.trail.destination.latitude,
          widget.trail.destination.longitude);
    } else {
      weatherDataDaily = [];
    }

    trailReviews = await reviewRepository.getTrailReviewsById(widget.trail.id!);

    for (int i = 0; i < weatherDataDaily!.length; i = i + 1) {
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
            children: [
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
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () {
              final timestamp = DateTime.now().millisecondsSinceEpoch;
              final random = path.basenameWithoutExtension(Uri.base.toString());
              final fileName = 'route_$timestamp$random.kml';

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MapScreen(trail: widget.trail, fileName: fileName)));
            },
            child: Icon(Icons.add),
          ),
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
                                itemCount: widget.trail.images.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Stack(
                                    children: [
                                      Hero(
                                        tag: widget.heroTag,
                                        child: Image.asset(
                                          widget.trail.images[index].toString(),
                                          height: size.height,
                                          width: size.width,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Container(
                                          height: size.height,
                                          width: size.width,
                                          decoration: BoxDecoration(
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
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: 30.0,
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
                                      Text(widget.trail.title,
                                          style: GoogleFonts.poppins(
                                              fontSize: 28.0,
                                              fontWeight: FontWeight.bold,
                                              color: kLightColor)),
                                      SizedBox(
                                        width: 3.0,
                                      ),
                                      Text(
                                          widget.trail.rating
                                              .toStringAsPrecision(2),
                                          style: GoogleFonts.poppins(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.normal,
                                              color: kLightColor)),
                                      SizedBox(
                                        width: 3.0,
                                      ),
                                      Icon(Icons.star,
                                          color: kRatingColor, size: 17),
                                    ]),
                                    SizedBox(
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
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Text(
                                                    '${widget.trail.distance.round().toString()}km',
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
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Text(
                                                    '${widget.trail.altitude.round().toString()}m',
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
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Text(
                                                    widget
                                                        .trail.difficulty.name,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: kLightColor)),
                                              ],
                                            ),
                                          ]),
                                    ),
                                    SizedBox(
                                      height: 28.0,
                                    ),
                                    SizedBox(
                                      height: 100.0,
                                      width: MediaQuery.of(context).size.width,
                                      child: ListView.builder(
                                          physics: BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: weatherDataDaily!.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Stack(children: <Widget>[
                                              DailyWeatherWidget(
                                                  index: index,
                                                  daily:
                                                      weatherDataDaily![index],
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
                            padding: EdgeInsets.all(0.0),
                            constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height -
                                  MediaQuery.of(context).padding.top -
                                  MediaQuery.of(context).padding.bottom,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: hexStringToColor("#ffffff"),
                                borderRadius: BorderRadius.only(),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 15,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (widget.trail.routes.isNotEmpty)
                                      Container(
                                          height: widget.trail.routes.length
                                                  .toDouble() *
                                              75,
                                          child: Column(
                                            children: widget.trail.routes.keys
                                                .map((key) {
                                              String value =
                                                  widget.trail.routes[key]!;
                                              return RouteWidget(
                                                destination:
                                                    widget.trail.destination,
                                                name: value,
                                                route: key,
                                              );
                                            }).toList(),
                                          )),
                                    SizedBox(height: 18),
                                    Text(
                                      widget.trail.content,
                                      style: darkNormalFont,
                                    ),
                                    SizedBox(height: 28),
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
                                    SizedBox(height: 20),
                                    normalButton(context, 'Add review', () {
                                      Navigator.push<bool>(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddReviewScreen(
                                              trail: widget.trail,
                                              email: currentUser!.email!),
                                        ),
                                      );
                                    }),
                                    SizedBox(height: 20),
                                    SizedBox(
                                      height: 330,
                                      child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: trailReviews.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ReviewWidget(
                                              review: trailReviews[index],
                                              email: currentUser!.email!);
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 20),
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

  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
