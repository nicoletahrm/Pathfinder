import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pathfinder_app/repositories/user_repository.dart';
import '../models/review.dart';
import '../utils/covert.dart';

class ReviewRepository {
  final FirebaseFirestore database = FirebaseFirestore.instance;
  final UserRepository userRepository = UserRepository();

  Future<List<Review>> getTrailReviewsByRef(DocumentReference ref) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('review')
        .where('trail', isEqualTo: ref)
        .get();

    List<Review> reviews = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
        in snapshot.docs) {
      Map<String, dynamic> data = documentSnapshot.data();
      Review review = Review.fromJson(data);
      reviews.add(review);
    }

    return reviews;
  }

  addReview(String content, List<String> images, String rating,
      DocumentReference<Object?>? ref, DocumentReference<Object?>? user) async {
    try {
      CollectionReference collectionRef = database.collection('review');

      DocumentReference documentRef = collectionRef.doc();

      await documentRef.set({
        'content': content,
        'rating': rating,
        'trail': ref,
        'user': user,
        'images': images,
      });

      final trailSnapshot = await ref?.get();

      Map<String, dynamic>? trailData =
          trailSnapshot?.data() as Map<String, dynamic>?;
      double currentRating = stringToDouble(trailData?['rating'] ?? 0);

      double averageRating = (stringToDouble(rating) + currentRating) / 2;
      String averageRatingString = averageRating.toString();

      await ref?.update({'rating': averageRatingString});

      print('Data added to Firestore successfully!');
    } catch (error) {
      print('Error adding data to Firestore: $error');
    }
  }
}
