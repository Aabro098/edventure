class MessageModel {
  final String type;      
  final String message;   
  final String sourceId;  
  final String targetId;  
  final String time;     

  MessageModel({
    required this.type,
    required this.message,
    required this.sourceId,
    required this.targetId,
    required this.time,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      type: json['sourceId'] == json['currentUserId'] ? 'source' : 'destination',
      message: json['message'] ?? '',
      sourceId: json['sourceId'] ?? '',
      targetId: json['targetId'] ?? '',
      time: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp']).toString().substring(11, 16)
          : DateTime.now().toString().substring(11, 16),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'message': message,
      'sourceId': sourceId,
      'targetId': targetId,
      'time': time,
    };
  }
}