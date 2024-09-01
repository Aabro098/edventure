import 'dart:convert';

class NotificationModel {
  final String id;
  final String senderId;
  final String message;
  final bool notificationStatus;
  final bool responseStatus;
  final DateTime dateTime;

  NotificationModel({
    required this.id,
    required this.senderId,
    required this.message,
    required this.notificationStatus,
    required this.responseStatus,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'id': id});
    result.addAll({'senderId': senderId});
    result.addAll({'message': message});
    result.addAll({'notificationStatus': notificationStatus});
    result.addAll({'responseStatus': responseStatus});
    result.addAll({'dateTime': dateTime.toIso8601String()});
    return result;
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['_id'] ?? '',
      senderId: map['sender'] ?? '',
      message: map['message'] ?? '',
      notificationStatus: map['notificationStatus'] ?? false,
      responseStatus: map['responseStatus'] ?? false,
      dateTime: DateTime.parse(map['dateTime']),
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source));
}
