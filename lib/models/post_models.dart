import 'dart:convert';
import 'package:edventure/models/comment.dart';
import 'package:edventure/models/report.dart';


class Post {
  final String user;
  final String description;
  final String? image;
  final DateTime createdAt;
  final List<Comment> comments;
  final List<String> likes;
  final List<String> shares;
  final List<Report> reports;
  Post({
    required this.user,
    required this.description,
    this.image,
    required this.createdAt,
    required this.comments,
    required this.likes,
    required this.shares,
    required this.reports,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'user': user});
    result.addAll({'description': description});
    if(image != null){
      result.addAll({'image': image});
    }
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});
    result.addAll({'comments': comments.map((x) => x.toMap()).toList()});
    result.addAll({'likes': likes});
    result.addAll({'shares': shares});
    result.addAll({'reports': reports.map((x) => x.toMap()).toList()});
  
    return result;
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      user: map['user'] ?? '',
      description: map['description'] ?? '',
      image: map['image'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      comments: List<Comment>.from(map['comments']?.map((x) => Comment.fromMap(x))),
      likes: List<String>.from(map['likes']),
      shares: List<String>.from(map['shares']),
      reports: List<Report>.from(map['reports']?.map((x) => Report.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source));
}
