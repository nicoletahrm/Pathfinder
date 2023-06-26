import 'package:flutter/material.dart';
import 'package:pathfinder_app/repositories/trail_respository.dart';
import 'package:pathfinder_app/screens/trail_map_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/trail.dart';
import '../models/route_request.dart';
import '../repositories/request_repository.dart';
import '../utils/fonts.dart';
import '../widgets/custom_circular_progress_indicator.dart';
import 'login_screen.dart';

class AdminScreen extends StatefulWidget {
  @override
  State<AdminScreen> createState() => AdminScreenState();
}

class AdminScreenState extends State<AdminScreen> {
  final RequestRepository requestRepository = RequestRepository();
  final TrailRepository trailRepository = TrailRepository();
  late List<RouteRequest> requests;
  late Trail newTrail;
  late Trail trail;

  Future<void> init() async {
    requests = await requestRepository.getRequests();
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
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Failed to initialize screen: ${snapshot.error}');
        } else {
          return buildTrail(context);
        }
      },
    );
  }

  Widget buildTrail(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
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
                  "Admin",
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
                        return LoginScreen();
                      }),
                    );
                  },
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final request = requests[index];
                  return ListTile(
                    title: Text(request.route, style: darkNormalFont),
                    //subtitle: Text(request.filePath),
                    trailing: Icon(
                      request.isAccepted ? Icons.check_circle : Icons.cancel,
                      color: request.isAccepted ? Colors.green : Colors.red,
                    ),
                    onTap: () async {
                      trail =
                          await trailRepository.getTrailById(request.trailId);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TrailMapScreen(
                                  destination: trail.destination,
                                  route: request.filePath)));
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
