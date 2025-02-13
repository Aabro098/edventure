import 'dart:convert';
import 'package:edventure/constants/variable.dart';
import 'package:http/http.dart' as http;
import 'package:edventure/models/review.dart';

class ReviewService {
  final String baseUrl;

  ReviewService({required this.baseUrl});

  Future<bool> submitReview(Review review) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/submit_review'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: review.toJson(),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
            'Failed to submit review. Status Code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> deleteReview({
    required String reviewId,
    required String userId,
    required String senderId,
    required int rating,
  }) async {
    final response = await http.delete(
      Uri.parse('$uri/delete_review'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'reviewId': reviewId,
        'userId': userId,
        'senderId': senderId,
        'rating': rating,
      }),
    );

    if (response.statusCode == 200) {
      return {'success': true, 'message': 'Review deleted successfully'};
    } else {
      throw Exception('Failed to delete review: ${response.body}');
    }
  }

  Future<List<Review>> fetchReviewsByUserId(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/reviews/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((item) => Review.fromMap(item)).toList();
      } else {
        throw Exception(
            'Failed to load reviews. Status Code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      return [];
    }
  }
}
