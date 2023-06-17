import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String content;
  final DocumentReference<Object>? user;
  final List<DocumentReference<Object>?>? replies;

  Comment({
    required this.content,
    required this.user,
    this.replies,
  });

  Map<String, dynamic> toJson() {
    return {
      "content": content,
      "user": user,
      "replies": replies,
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    final data = json;

    return Comment(
      content: data["content"],
      user: data["user"],
     replies: List<DocumentReference<Object>?>.from(data["replies"]),
    );
  }
}
