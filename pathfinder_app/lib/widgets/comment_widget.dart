import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/comment.dart';
import '../models/user.dart';
import '../repositories/comment_repositroy.dart';
import '../repositories/user_repository.dart';
import '../utils/constant_colors.dart';
import '../utils/covert.dart';
import 'custom_circular_progress_indicator.dart';
import 'custom_dialog.dart';

class CommentWidget extends StatefulWidget {
  final String content;
  final DocumentReference<Object?>? ref;
  final List<DocumentReference<Object>?>? replies;

  const CommentWidget(
      {Key? key,
      required this.content,
      required this.ref,
      required this.replies})
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
  late List<Comment> repliesList;

  Future<void> init() async {
    user = await userRepository.getUserByRef(widget.ref);
    repliesList = await fetchComments();
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
          return buildReview(context);
        }
      },
    );
  }

  Widget buildReview(BuildContext context) {
    bool showAllReplies = false; // Flag to track if all replies should be shown

    return InkWell(
        child: Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
            width: 500,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 25,
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
                                fontSize: 18.0,
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
                                fontSize: 16.0,
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
              if (repliesList.length > 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (repliesList.length > 0)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                showAllReplies = true;
                              });
                            },
                            child: Text(
                                'Show all replies (${repliesList.length})'),
                          ),

                          if (showAllReplies) // Update this condition
                          ...repliesList.map((reply) {
                            return Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text(reply.toJson()['content']),
                            );
                          }).toList(),

                          if (showAllReplies && repliesList.length > 2)
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  showAllReplies = false;
                                });
                              },
                              child: Text('Hide replies'),
                            ),
                        ],
                      ),
                  ],
                ),
            ])));
  }

  Future<List<Comment>> fetchComments() async {
    List<Comment> comments = [];

    for (DocumentReference<Object>? commentRef in widget.replies!) {
      if (commentRef != null) {
        Comment comment = await commentRepository.getCommentByRef(commentRef);
        comments.add(comment);
      }
    }
    return comments;
  }
}
