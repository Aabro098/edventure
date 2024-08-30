import 'dart:convert';

class NotificationModel {
    final String senderId;
  final String message;
  final DateTime dateTime;
  NotificationModel({
    required this.senderId,
    required this.message,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'senderId': senderId});
    result.addAll({'message': message});
    result.addAll({'dateTime': dateTime.millisecondsSinceEpoch});
  
    return result;
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      senderId: map['senderId'] ?? '',
      message: map['message'] ?? '',
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime']),
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) => NotificationModel.fromMap(json.decode(source));
}
