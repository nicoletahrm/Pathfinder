import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pathfinder_app/repositories/trail_respository.dart';
import 'package:pathfinder_app/repositories/user_repository.dart';
import '../models/time.dart';
import '../models/trail.dart';
import '../models/user.dart';
import '../repositories/event_repository.dart';
import '../utils/constant_colors.dart';
import '../utils/covert.dart';
import '../widgets/custom_nav_bar.dart';
import '../widgets/reusable_widget.dart';

class AddEventScreen extends StatefulWidget {
  final String email;

  AddEventScreen({Key? key, required this.email}) : super(key: key);

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final EventRepository eventRepository = EventRepository();
  final TrailRepository trailRepository = TrailRepository();
  final UserRepository userRepository = UserRepository();
  final TextEditingController meetingPlaceController = TextEditingController();
  final TextEditingController maxParticipantsController =
      TextEditingController();
  late ScrollController _scrollController;
  late User user;

  String? selectedTrail;
  late Trail trail;
  String? meetigPlace;
  late DateTime selectedDate = DateTime.now();
  late TimeOfDay selectedTime = TimeOfDay.now();
  int maxParticipants = 0;
  late List<Trail> trails;

  Future<void> init() async {
    trails = (await trailRepository.getAllTrails());
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
  initState() {
    super.initState();
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
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Failed to initialize AddEventScreen: ${snapshot.error}');
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
                        trail =
                            await trailRepository.getTrailByTitle(selectedTrail!);
                      });
                    },
                    items: trails.map((Trail trail) {
                      return DropdownMenuItem<String>(
                        value: trail.title,
                        child: Text(trail.title),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      hintText: 'Trail',
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
                  reusableIntTextField(
                    'Maximum participants',
                    Icons.group,
                    maxParticipantsController,
                    (int value) {
                      //setState(() {
                      maxParticipants = value;
                      //});
                    },
                  ),
                  SizedBox(height: 20),
                  reusableNormalTextField(
                    'Meeting place',
                    Icons.location_pin,
                    meetingPlaceController,
                    true,
                    () {
                      meetigPlace = meetingPlaceController.text;
                    },
                  ),
                  SizedBox(height: 20),
                  normalButton(
                    context,
                    'Add hike',
                    () async {
                      final Time time =
                          Time(date: selectedDate, time: selectedTime);

                      await eventRepository.addEvent(trail.id!, user.id,
                          maxParticipants, meetigPlace!, time);
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
