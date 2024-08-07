import 'dart:convert';


class Comment {
  final String user;
  final String text;
  final DateTime createdAt;
  Comment({
    required this.user,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'user': user});
    result.addAll({'text': text});
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});
  
    return result;
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      user: map['user'] ?? '',
      text: map['text'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) => Comment.fromMap(json.decode(source));
}
