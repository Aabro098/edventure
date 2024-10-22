class MessageModel {
  final String senderId;
  final String senderSocketId;
  final String recipientId;
  final String recipientSocketId;
  final String message;
  final DateTime timestamp;

  MessageModel({
    required this.senderId,
    required this.senderSocketId,
    required this.recipientId,
    required this.recipientSocketId,
    required this.message,
    required this.timestamp,
  });

  // Factory method to create a Message object from a JSON map
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderId: json['senderId'],
      senderSocketId: json['senderSocketId'],
      recipientId: json['recipientId'],
      recipientSocketId: json['recipientSocketId'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  // Method to convert a Message object to JSON
  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'senderSocketId': senderSocketId,
      'recipientId': recipientId,
      'recipientSocketId': recipientSocketId,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
