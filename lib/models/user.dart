import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String phone;
  String profileImage;
  String address;
  final String bio;
  final String about;
  int rating;
  int numberRating;
  final String education;
  final String type;
  final String username;
  final bool isVerified;
  final List<String> review;
  final String socketId;
  final String token;
  final List<String> teachingAddress;
  final List<String> skills;
  final List<String> contacts;
  List<String> enrolledClasses;
  bool progress;
  String gender;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.profileImage,
    required this.address,
    required this.bio,
    required this.about,
    required this.rating,
    required this.numberRating,
    required this.education,
    required this.type,
    required this.username,
    required this.isVerified,
    required this.review,
    required this.socketId,
    required this.token,
    required this.teachingAddress,
    required this.skills,
    required this.contacts,
    required this.gender,
    required this.progress,
    required this.enrolledClasses,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      phone: map['phone'] ?? '',
      profileImage: map['profileImage'] ?? '',
      address: map['address'] ?? '',
      bio: map['bio'] ?? '',
      about: map['about'] ?? '',
      rating: map['rating']?.toInt() ?? 0,
      numberRating: map['numberRating']?.toInt() ?? 0,
      education: map['education'] ?? '',
      type: map['type'] ?? '',
      username: map['username'] ?? '',
      isVerified: map['isVerified'] ?? false,
      review: List<String>.from(map['review'] ?? []),
      socketId: map['socketId'] ?? '',
      token: map['token'] ?? '',
      teachingAddress: List<String>.from(map['teachingAddress'] ?? []),
      skills: List<String>.from(map['skills'] ?? []),
      contacts: List<String>.from(map['skills'] ?? []),
      gender: map['gender'] ?? '',
      progress: map['progress'] ?? false,
      enrolledClasses: List<String>.from(map['enrolledClasses'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'profileImage': profileImage,
      'address': address,
      'bio': bio,
      'about': about,
      'rating': rating,
      'numberRating': numberRating,
      'education': education,
      'type': type,
      'username': username,
      'isVerified': isVerified,
      'review': review,
      'socketId': socketId,
      'token': token,
      'teachingAddress': teachingAddress,
      'skills': skills,
      'contacts': contacts,
      'gender': gender,
      'progress': progress,
      'enrolledClasses': enrolledClasses,
    };
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
