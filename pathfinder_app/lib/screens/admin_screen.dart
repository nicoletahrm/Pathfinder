import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/trail_request.dart';
import '../repositories/request_repository.dart';
import '../widgets/custom_circular_progress_indicator.dart';
import 'login_screen.dart';

class AdminScreen extends StatefulWidget {
  @override
  State<AdminScreen> createState() => AdminScreenState();
}

class AdminScreenState extends State<AdminScreen> {
  final RequestRepository requestRepository = RequestRepository();
  late List<TrailRequest> requests;

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
                    title: Text(request.title),
                    subtitle: Text(request.filePath),
                    onTap: () {
                      print('Clicked on: ${request.title}');
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
