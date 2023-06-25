import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pathfinder_app/models/comment.dart';
import 'package:pathfinder_app/repositories/comment_repositroy.dart';
import 'package:pathfinder_app/repositories/trail_respository.dart';
import 'package:pathfinder_app/repositories/user_repository.dart';
import 'package:pathfinder_app/widgets/comment_widget.dart';
import 'package:pathfinder_app/widgets/custom_nav_bar.dart';
import '../models/event.dart';
import '../models/trail.dart';
import '../models/user.dart';
import '../repositories/event_repository.dart';
import '../utils/fonts.dart';
import '../widgets/custom_circular_progress_indicator.dart';
import '../widgets/event_widget.dart';
import '../widgets/reusable_widget.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;
  final String email;

  EventDetailsScreen({Key? key, required this.event, required this.email})
      : super(key: key);

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final TrailRepository trailRepository = TrailRepository();
  final EventRepository eventRepository = EventRepository();
  final UserRepository userRepository = UserRepository();
  final CommentRepository commentRepository = CommentRepository();
  late DocumentReference<Object?> currentUserRef;
  late Trail? trail;
  late List<User?> users;
  late String buttonText;
  late List<Comment> comments;
  bool shouldReloadScreen = false;

  @override
  void initState() {
    super.initState();
    //init();
  }

  Future<void> init() async {
    trail = await trailRepository.getTrailByRef(widget.event.trail);
    users =
        await userRepository.getEventParticipants(widget.event.participants);
    currentUserRef = await userRepository.getUserRefByEmail(widget.email);
    comments = await fetchComments();

    if (widget.event.participants.contains(currentUserRef)) {
      buttonText = "Don't go";
    } else {
      buttonText = "Go";
    }
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
          return Text('Failed to initialize event: ${snapshot.error}');
        } else {
          return buildEvent(context);
        }
      },
    );
  }

  Widget buildEvent(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 30.0,
              horizontal: 20.0,
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.arrow_back),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: Offset(0, 1),
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                  child: EventWidget(
                    event: widget.event,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 0.0,
                    bottom: 10.0,
                    left: 30.0,
                    right: 30.0,
                  ),
                  child: Row(
                    children: List<Widget>.generate(
                      widget.event.participants.length,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'People going',
                                    style: darkBoldFont,
                                  ),
                                  content: SizedBox(
                                    width: double.maxFinite,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: users.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return ListTile(
                                          leading: CircleAvatar(
                                            radius: 20.0,
                                            backgroundImage: AssetImage(
                                                users[index]!.profilePhoto),
                                          ),
                                          title: Text(
                                            users[index]!.username,
                                            style: darkNormalFont,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child:
                                          Text('Close', style: darkNormalFont),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 5.0),
                            child: CircleAvatar(
                              radius: 12.0,
                              backgroundImage:
                                  AssetImage(users[index]!.profilePhoto),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                normalButton(context, buttonText, () async {
                  if (widget.event.maxParticipants == 0) {
                    showValidationDialogWidget(
                      context,
                      'Fail',
                      'No free spots left.',
                    );
                  } else {
                    bool isParticipant =
                        widget.event.participants.contains(currentUserRef);

                    if (isParticipant == true) {
                      await eventRepository.removeParticipant(
                          widget.event, currentUserRef);
                      await userRepository.removeEventToUser(
                          currentUserRef, widget.event.id);
                    } else {
                      await eventRepository.updateParticipants(
                          widget.event, currentUserRef);
                      await userRepository.addEventToUser(
                          currentUserRef, widget.event.id);
                    }

                    setState(() {
                      shouldReloadScreen = true;
                    });
                  }
                }),
                SizedBox(height: 20),
                SizedBox(
                  height: 400,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: comments.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CommentWidget(
                        content: comments[index].content,
                        userRef: comments[index].user,
                        eventRef: widget.event.id
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Future<List<Comment>> fetchComments() async {
    List<Comment> comments = [];

    for (DocumentReference<Object?>? commentRef in widget.event.comments) {
      if (commentRef != null) {
        Comment comment = await commentRepository.getCommentByRef(commentRef);
        comments.add(comment);
      }
    }
    return comments;
  }
}
