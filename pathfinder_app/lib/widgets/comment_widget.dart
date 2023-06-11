import 'package:flutter/material.dart';

class CommentWidget extends StatefulWidget {
  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  Future<void> init() async {}

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
          return const CircularProgressIndicator();
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

    return Scaffold();
  }
}
