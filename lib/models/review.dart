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

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'senderId': senderId});
    result.addAll({'description': description});
    result.addAll({'rating': rating});
  
    return result;
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      description: map['description'] ?? '',
      rating: map['rating']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Review.fromJson(String source) => Review.fromMap(json.decode(source));
}
