import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pathfinder_app/repositories/request_repository.dart';
import 'package:pathfinder_app/repositories/user_repository.dart';
import 'package:pathfinder_app/screens/home_screen.dart';
import 'package:pathfinder_app/widgets/custom_nav_bar.dart';
import 'package:pathfinder_app/widgets/reusable_widget.dart';
import '../models/user.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/custom_circular_progress_indicator.dart';
import 'draw_route.dart';

class RecordRouteScreen extends StatefulWidget {
  final String email, fileName, trailId;
  final List<LatLng> list;

  RecordRouteScreen(
      {Key? key,
      required this.email,
      required this.fileName,
      required this.trailId,
      required this.list})
      : super(key: key);

  @override
  _RecordRouteScreenState createState() => _RecordRouteScreenState();
}

class _RecordRouteScreenState extends State<RecordRouteScreen> {
  late User user;
  final UserRepository userRepository = UserRepository();
  final RequestRepository requestRepository = RequestRepository();
  TextEditingController _routeController = TextEditingController();
  TextEditingController _signController = TextEditingController();
  late ScrollController _scrollController;

  Future<void> init() async {
    user = await userRepository.getUserByEmail(widget.email);

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.offset <=
          _scrollController.position.minScrollExtent) {
        _scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _routeController.dispose();
    _signController.dispose();
    super.dispose();
  }

  @override
  initState() {
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
          return Text('Failed to initialize screen: ${snapshot.error}');
        } else {
          return buildScreen(context);
        }
      },
    );
  }

  Widget buildScreen(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 70.0,
                      ),
                      Text(
                        "Request a new trail",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: "ProximaNovaBold",
                        ),
                      ),
                      SizedBox(
                        height: 60.0,
                      ),
                      reusableNormalTextField(
                          'Route', Icons.hiking, _routeController, true, () {}),
                      SizedBox(height: 15.0),
                      reusableNormalTextField('Sign', Icons.icecream_outlined,
                          _signController, true, () {}),
                      SizedBox(height: 15.0),
                      Text(widget.fileName),
                      normalButton(context, 'See trail on map', () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DrawMapScreen(list: widget.list)));
                      }),
                      SizedBox(height: 30.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          normalButton(context, 'Request', () async {
                            await requestRepository.addRequest(
                                widget.trailId,
                                _routeController.text,
                                _signController.text,
                                widget.fileName);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Request has been send successfully!'),
                              ),
                            );
                          }),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar());
  }

  void validation() async {
    if (_routeController.text.isEmpty || _signController.text.isEmpty) {
      CustomDialog.show(
        context,
        "Empty fields",
        "Please fill in all fields.",
      );
    }
  }
}
