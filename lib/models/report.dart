import 'dart:convert';


class Report {
  final String user;
  final String reason;
  final DateTime createdAt;
  Report({
    required this.user,
    required this.reason,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'user': user});
    result.addAll({'reason': reason});
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});
  
    return result;
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      user: map['user'] ?? '',
      reason: map['reason'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Report.fromJson(String source) => Report.fromMap(json.decode(source));
}
