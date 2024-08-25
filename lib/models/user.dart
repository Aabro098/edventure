import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String phone;
  final String profileImage;
  final String coverImage;
  final String address;
  final String bio;
  final String about;
  final int rating;
  final int ratingNumber;
  final String education;
  final String status;
  final String type;
  final String username;
  final bool isVerified;
  final bool isEmailVerified;
  final bool isAvailable;
  final List<String> posts;
  final List<String> review;
  final List<String> notification;
  final String token;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.profileImage,
    required this.coverImage,
    required this.address,
    required this.bio,
    required this.about,
    required this.rating,
    required this.ratingNumber,
    required this.education,
    required this.status,
    required this.type,
    required this.username,
    required this.isVerified,
    required this.isEmailVerified,
    required this.isAvailable,
    required this.posts,
    required this.review,
    required this.notification,
    required this.token,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      phone: map['phone'] ?? '',
      profileImage: map['profileImage'] ?? '',
      coverImage: map['coverImage'] ?? '',
      address: map['address'] ?? '',
      bio: map['bio'] ?? '',
      about: map['about'] ?? '',
      rating: map['rating']?.toInt() ?? 0,
      ratingNumber: map['ratingNumber']?.toInt() ?? 0,
      education: map['education'] ?? '',
      status: map['status'] ?? '',
      type: map['type'] ?? '',
      username: map['username'] ?? '',
      isVerified: map['isVerified'] ?? false,
      isEmailVerified: map['isEmailVerified'] ?? false,
      isAvailable: map['isAvailable'] ?? false,
      posts: List<String>.from(map['posts'] ?? []),
      review: List<String>.from(map['review'] ?? []),
      notification: List<String>.from(map['notification'] ?? []),
      token: map['token'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'profileImage': profileImage,
      'coverImage': coverImage,
      'address': address,
      'bio': bio,
      'about': about,
      'rating': rating,
      'ratingNumber': ratingNumber,
      'education': education,
      'status': status,
      'type': type,
      'username': username,
      'isVerified': isVerified,
      'isEmailVerified': isEmailVerified,
      'isAvailable': isAvailable,
      'posts': posts,
      'review': review,
      'notification' : notification,
      'token': token,
    };
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
