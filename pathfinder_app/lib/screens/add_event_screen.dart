import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../repositories/event_repository.dart';
import '../utils/constant_colors.dart';
import '../utils/covert.dart';

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final EventRepository trailRepository = EventRepository();

  Future<void> init() async {}

  @override
  void initState() {
    super.initState();
    //userRepository.getUserRefByEmail(user?.email);
    //init();
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
              CircularProgressIndicator(
                color: kButtonColor,
                backgroundColor: Colors.black12.withOpacity(0.5),
              ),
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
    //Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
      child: Column(
        children: [
          SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                  (states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.black26;
                    }
                    return hexStringToColor("#44564a");
                  },
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              child: Text(
                'Add hike',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
