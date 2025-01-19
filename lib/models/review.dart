import 'dart:convert';

class Review {
  final String id;
  final String senderId;
  final String description;
  final int rating;

  Review({
    required this.id,
    required this.senderId,
    required this.description,
    required this.rating,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['_id'] ?? '',
      senderId: map['senderId'] ?? '',
      description: map['description'] ?? '',
      rating: map['rating']?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'senderId': senderId,
      'description': description,
      'rating': rating,
    };
  }

  String toJson() => json.encode(toMap());

  factory Review.fromJson(String source) => Review.fromMap(json.decode(source));
}
