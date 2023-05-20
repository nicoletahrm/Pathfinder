// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewWidget extends StatefulWidget {
  final String? trailId;

  const ReviewWidget({Key? key, required this.trailId}) : super(key: key);

  @override
  _ReviewWidgetState createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('trail')
                  .doc(widget.trailId)
                  .collection('reviews')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final reviews = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];

                    return ListTile(
                      title: Text(review['content']),
                      subtitle: Text(review['user']),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(hintText: 'Add a review'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    _addComment();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addComment() {
    final content = _commentController.text;

    if (content.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('trail')
          .doc(widget.trailId)
          .collection('reviews')
          .add({
        'content': content,
        //'user': /* add user ID or display name here */
      });

      _commentController.clear();
    }
  }
}
