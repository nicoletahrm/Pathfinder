import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review.dart';
import '../utils/covert.dart';

class ReviewRepository {
  final FirebaseFirestore database = FirebaseFirestore.instance;
  Future<List<Review>> getTrailReviewsById(String trailId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('review')
        .where('trail', isEqualTo: trailId)
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

  Future<void> addReview(
    String content,
    List<String> images,
    String rating,
    String trailId,
    String userId,
  ) async {
    try {
      DocumentSnapshot trailSnapshot =
          await database.collection('trail').doc(trailId).get();

      if (!trailSnapshot.exists) {
        print('Trail with ID $trailId does not exist.');
        return;
      }

      Map<String, dynamic>? trailData =
          trailSnapshot.data() as Map<String, dynamic>?;
      double currentRating = stringToDouble(trailData?['rating']);

      double newRating = (stringToDouble(rating) + currentRating) / 2;
      String newRatingString = newRating.toStringAsFixed(2);

      CollectionReference collectionRef = database.collection('review');
      DocumentReference documentRef = collectionRef.doc();

      await documentRef.set({
        'id': documentRef.id,
        'content': content,
        'rating': rating,
        'trail': trailId,
        'user': userId,
        'images': images,
      });

      await database.collection('trails').doc(trailId).update({
        'rating': newRatingString,
      });

      print('Review added and trail rating updated successfully!');
    } catch (error) {
      print('Error adding review and updating trail rating: $error');
    }
  }
}
