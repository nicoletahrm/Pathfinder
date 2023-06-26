import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pathfinder_app/repositories/request_repository.dart';
import 'package:pathfinder_app/repositories/user_repository.dart';
import 'package:pathfinder_app/screens/home_screen.dart';
import 'package:pathfinder_app/widgets/custom_nav_bar.dart';
import 'package:pathfinder_app/widgets/reusable_widget.dart';
import '../models/user.dart';
import '../widgets/custom_circular_progress_indicator.dart';
import 'draw_route.dart';

class RecordRouteScreen extends StatefulWidget {
  final String email, fileName;
  final List<LatLng> list;

  RecordRouteScreen(
      {Key? key,
      required this.email,
      required this.fileName,
      required this.list})
      : super(key: key);

  @override
  _RecordRouteScreenState createState() => _RecordRouteScreenState();
}

class _RecordRouteScreenState extends State<RecordRouteScreen> {
  late DocumentReference ref;
  late User user;
  final UserRepository userRepository = UserRepository();
  final RequestRepository requestRepository = RequestRepository();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _sourceController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  TextEditingController _signController = TextEditingController();

  Future<void> init() async {
    ref = await userRepository.getUserRefByEmail(widget.email);
    user = await userRepository.getUserByRef(ref);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _sourceController.dispose();
    _destinationController.dispose();
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
          return buildProfile(context);
        }
      },
    );
  }

  Widget buildProfile(BuildContext context) {
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
                          'Name', Icons.hiking, _titleController, true, () {}),
                      SizedBox(height: 15.0),
                      reusableNormalTextField('Start location',
                          Icons.location_pin, _sourceController, true, () {}),
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
                                _titleController.text,
                                _sourceController.text,
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
}
