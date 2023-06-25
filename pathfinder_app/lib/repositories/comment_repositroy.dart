import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pathfinder_app/models/comment.dart';

class CommentRepository {
  final FirebaseFirestore database = FirebaseFirestore.instance;

  Future<List<Comment>> getComments() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await database.collection("comment").get();

    return snapshot.docs
        .map((docSnapshot) => Comment.fromJson(docSnapshot.data()))
        .toList();
  }

  Future<Comment> getCommentByRef(DocumentReference<Object?>? ref) async {
    final commentSnapshot = await ref!.get();

    if (commentSnapshot.exists) {
      final commentData = commentSnapshot.data() as Map<String, dynamic>;
      return Comment.fromJson(commentData);
    }

    throw Exception('Comment not found.');
  }

  addComment(Comment c, String eventRef) async {
    try {
      CollectionReference collectionRef = database.collection('comment');
      DocumentReference<Object?> documentRef = collectionRef.doc();

      Comment comment = Comment(
        content: c.content,
        user: c.user,
      );

      await documentRef.set({
        'content': comment.content,
        'user': comment.user,
      });
      print('Data added to Firestore successfully!');
    } catch (error) {
      print('Error adding data to Firestore: $error');
    }
  }
}
