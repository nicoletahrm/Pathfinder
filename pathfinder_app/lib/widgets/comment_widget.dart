import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';
import '../utils/fonts.dart';
import 'custom_circular_progress_indicator.dart';

class CommentWidget extends StatefulWidget {
  final String? content;
  final DocumentReference<Object?>? userRef;

  const CommentWidget({Key? key, required this.content, required this.userRef})
      : super(key: key);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final UserRepository userRepository = UserRepository();
  late User user;

  Future<void> init() async {
    user = await userRepository.getUserByRef(widget.userRef);
  }

  @override
  void initState() {
    super.initState();
    //init();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CustomCircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Failed to initialize comment: ${snapshot.error}');
        } else {
          return buildComment(context);
        }
      },
    );
  }

  Widget buildComment(BuildContext context) {
    //Size size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
      width: 500,
      child: Row(
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
                  children: [Text(user.username, style: darkBoldFont)],
                ),
                Row(
                  children: [
                    Text(
                      widget.content!,
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
    );
  }
}
