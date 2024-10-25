class MessageModel {
  final String sourceId;
  final String targetId;
  final String message;
  final String time;
  final String type;

  MessageModel({
    required this.sourceId,
    required this.targetId,
    required this.message,
    required this.time,
    required this.type,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      sourceId: json['sourceId'],
      targetId: json['targetId'],
      message: json['message'],
      time: json['time'] ?? DateTime.now().toString().substring(11, 16),
      type: json['type'],
    );
  }
}