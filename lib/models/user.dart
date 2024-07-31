import 'dart:convert';

class User {
  final String id;
  final String email;
  final String name;
  final String password;
  final String address;
  final String phone;
  final String bio;
  final String status;
  final double rating;
  final String profileImage;
  final String coverImage;
  final String education;
  final String type;
  final String username;
  final String token;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
    required this.address,
    required this.phone,
    required this.bio,
    required this.status,
    required this.rating,
    required this.profileImage,
    required this.coverImage,
    required this.education,
    required this.type,
    required this.username,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'password': password,
      'address': address,
      'phone': phone,
      'bio': bio,
      'status': status,
      'rating': rating,
      'profileImage': profileImage,
      'coverImage': coverImage,
      'education': education,
      'type': type,
      'username': username,
      'token': token,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      password: map['password'] ?? '',
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      bio: map['bio'] ?? '',
      status: map['status'] ?? '',
      rating: map['rating']?.toDouble() ?? 0.0,
      profileImage: map['profileImage'] ?? '',
      coverImage: map['coverImage'] ?? '',
      education: map['education'] ?? '',
      type: map['type'] ?? '',
      username: map['username'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
