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
  final List<String> posts;
  final List<String> review;
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
    required this.posts,
    required this.review,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'email': email});
    result.addAll({'password': password});
    result.addAll({'phone': phone});
    result.addAll({'profileImage': profileImage});
    result.addAll({'coverImage': coverImage});
    result.addAll({'address': address});
    result.addAll({'bio': bio});
    result.addAll({'about': about});
    result.addAll({'rating': rating});
    result.addAll({'ratingNumber': ratingNumber});
    result.addAll({'education': education});
    result.addAll({'status': status});
    result.addAll({'type': type});
    result.addAll({'username': username});
    result.addAll({'isVerified': isVerified});
    result.addAll({'isEmailVerified': isEmailVerified});
    result.addAll({'posts': posts});
    result.addAll({'review': review});
    result.addAll({'token': token});
  
    return result;
  }

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
      posts: List<String>.from(map['posts']),
      review: List<String>.from(map['review']),
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
