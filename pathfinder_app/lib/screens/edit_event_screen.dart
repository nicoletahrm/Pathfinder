import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pathfinder_app/repositories/trail_respository.dart';
import 'package:pathfinder_app/repositories/user_repository.dart';
import 'package:pathfinder_app/utils/fonts.dart';
import '../models/event.dart';
import '../models/time.dart';
import '../models/trail.dart';
import '../repositories/event_repository.dart';
import '../utils/constant_colors.dart';
import '../utils/covert.dart';
import '../widgets/custom_nav_bar.dart';
import '../widgets/reusable_widget.dart';

class EditEventScreen extends StatefulWidget {
  final String email;
  final Event event;

  EditEventScreen({Key? key, required this.email, required this.event})
      : super(key: key);

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final EventRepository eventRepository = EventRepository();
  final TrailRepository trailRepository = TrailRepository();
  final UserRepository userRepository = UserRepository();
  final TextEditingController meetingPlaceController = TextEditingController();
  final TextEditingController maxParticipantsController =
      TextEditingController();
  late ScrollController _scrollController;

  String? selectedTrail;
  late Trail trail;
  late String? meetingPlace;
  late DateTime selectedDate = DateTime.now();
  late TimeOfDay selectedTime = TimeOfDay.now();
  late int maxParticipants;
  late List<Trail> trails;

  Future<void> init() async {
    trails = (await trailRepository.getAllTrails());
    trail = await trailRepository.getTrailById(widget.event.trail);
    maxParticipantsController.text = widget.event.maxParticipants.toString();
    meetingPlaceController.text = widget.event.meetingPlace;
    selectedDate = widget.event.time.date;
    selectedTime = widget.event.time.time;
    selectedTrail = trail.title;
    maxParticipants = widget.event.maxParticipants;

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
  initState() {
    super.initState();
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
          return Text(
              'Failed to initialize EditEventScreen: ${snapshot.error}');
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
        child: ListView(
            controller: _scrollController,
            shrinkWrap: false,
            children: [
              Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(Icons.arrow_back),
                    ),
                  ),
                  SizedBox(height: 20),
                  customButton(context, 'Date', () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            primaryColor: Color.fromARGB(255, 18, 30, 19),
                            hintColor: hexStringToColor("#f0f3f1"),
                            colorScheme: ColorScheme.light(
                              primary: Color.fromARGB(255, 18, 30, 19),
                            ),
                            buttonTheme: ButtonThemeData(
                              textTheme: ButtonTextTheme.normal,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  }),
                  Text(
                    DateFormat('dd-MM-yyyy').format(DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                    )),
                  ),
                  SizedBox(height: 20),
                  customButton(context, 'Time', () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            primaryColor: Color.fromARGB(255, 18, 30, 19),
                            hintColor: Color.fromARGB(255, 18, 30, 19),
                            colorScheme: ColorScheme.light(
                                primary: Color.fromARGB(255, 18, 30, 19)),
                            buttonTheme: ButtonThemeData(
                              textTheme: ButtonTextTheme.primary,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setState(() {
                        selectedTime = picked;
                      });
                    }
                  }),
                  Text(selectedTime.format(context)),
                  SizedBox(height: 30),
                  DropdownButtonFormField<String>(
                    value: selectedTrail,
                    onChanged: (String? newValue) async {
                      setState(() async {
                        selectedTrail = newValue;
                        trail = await trailRepository
                            .getTrailByTitle(selectedTrail!);
                      });
                    },
                    items: trails.map((Trail trail) {
                      return DropdownMenuItem<String>(
                        value: trail.title,
                        child: Text(trail.title, style: darkNormalFont),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      hintText: selectedTrail,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide:
                            BorderSide(width: 0, style: BorderStyle.none),
                      ),
                      filled: true,
                      fillColor: hexStringToColor("#f0f3f1"),
                      hintStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 20),
                  reusableIntTextField('Maximum participants', Icons.group,
                      maxParticipantsController, (int value) {
                    maxParticipants = value;
                  }),
                  SizedBox(height: 20),
                  reusableNormalTextField(
                    'Meeting place',
                    Icons.location_pin,
                    meetingPlaceController,
                    true,
                    () {
                      meetingPlace = meetingPlaceController.text;
                    },
                  ),
                  SizedBox(height: 20),
                  normalButton(
                    context,
                    'Save',
                    () async {
                      final Time time =
                          Time(date: selectedDate, time: selectedTime);

                      await eventRepository.updateEvent(widget.event.id,
                          trail.id!, maxParticipants, meetingPlace!, time);
                      setState(() {
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ],
              ),
            ]),
      )),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
