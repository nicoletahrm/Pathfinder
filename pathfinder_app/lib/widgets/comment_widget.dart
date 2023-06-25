import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user.dart';
import '../repositories/comment_repositroy.dart';
import '../repositories/user_repository.dart';
import '../utils/covert.dart';
import 'custom_circular_progress_indicator.dart';

class CommentWidget extends StatefulWidget {
  final String content;
  final DocumentReference<Object?>? userRef;
  final String eventRef;

  const CommentWidget(
      {Key? key,
      required this.content,
      required this.userRef,
      required this.eventRef,
      })
      : super(key: key);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final UserRepository userRepository = UserRepository();
  final CommentRepository commentRepository = CommentRepository();
  late User user;
  bool showReplyTextField = false;
  TextEditingController replyController = TextEditingController();

  bool showAllReplies = false;

  Future<void> init() async {
    user = await userRepository.getUserByRef(widget.userRef);
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
          return Text('Failed to initialize event: ${snapshot.error}');
        } else {
          return buildComment(context);
        }
      },
    );
  }

  Widget buildComment(BuildContext context) {
    return InkWell(
        child: Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
      width: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(user.profilePhoto),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          user.username,
                          style: GoogleFonts.poppins(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: hexStringToColor("#44564a"),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          widget.content,
                          style: GoogleFonts.poppins(
                            fontSize: 13.0,
                            fontWeight: FontWeight.normal,
                            color: kDefaultIconDarkColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
