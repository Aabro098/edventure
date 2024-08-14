import 'package:edventure/models/user.dart'; 

class Review {
  final User user; 
  final String description; 
  final int rating; 

  Review({
    required this.user,
    required this.description,
    required this.rating,
  }) {
    if (rating < 1 || rating > 5) {
      throw ArgumentError('Rating must be between 1 and 5');
    }
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      user: User.fromJson(json['user']), 
      description: json['description'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(), 
      'description': description,
      'rating': rating,
    };
  }
}
