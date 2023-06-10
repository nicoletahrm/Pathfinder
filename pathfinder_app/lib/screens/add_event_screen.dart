import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pathfinder_app/repositories/trail_respository.dart';
import '../models/event.dart';
import '../models/time.dart';
import '../models/trail.dart';
import '../repositories/event_repository.dart';
import '../utils/constant_colors.dart';
import '../utils/covert.dart';

class AddEventScreen extends StatefulWidget {
  AddEventScreen({Key? key}) : super(key: key);

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final EventRepository eventRepository = EventRepository();
  final TrailRepository trailRepository = TrailRepository();

  String? selectedTrail;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int maxParticipants = 0;
  late List<Trail> trails = [];

  late Event event;

  Future<void> init() async {
    trails = (await trailRepository.getAllTrails());
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
                CircularProgressIndicator(
                  color: kButtonColor,
                  backgroundColor: Colors.black12.withOpacity(0.5),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Failed to initialize trails: ${snapshot.error}');
        } else {
          return buildTrail(context);
        }
      },
    );
  }

  Widget buildTrail(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(Icons.arrow_back),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedTrail,
              onChanged: (String? newValue) {
                setState(() {
                  selectedTrail = newValue;
                  event.trail =
                      trailRepository.getRefTrailByTitle(selectedTrail!)
                          as DocumentReference<Object>?;
                });
              },
              items: trails.map((Trail trail) {
                return DropdownMenuItem<String>(
                  value: trail.title,
                  child: Text(trail.title),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Trail',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                    event.time.date = selectedDate!;
                  });
                }
              },
              child: Text(
                selectedDate != null
                    ? 'Date: ${selectedDate!.toLocal()}'
                    : 'Select Date',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) {
                  setState(() {
                    selectedTime = picked;
                    event.time.time = selectedTime!;
                  });
                }
              },
              child: Text(
                selectedTime != null
                    ? 'Time: ${selectedTime!.format(context)}'
                    : 'Select Time',
              ),
            ),
            TextFormField(
              onChanged: (String value) {
                maxParticipants = int.parse(value);
                event.maxParticipants = maxParticipants;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Maximum Participants',
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
              child: ElevatedButton(
                onPressed: () {
                  print('ok');
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
      ),
    ));
  }
}
