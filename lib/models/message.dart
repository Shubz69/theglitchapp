class Message {
  final String id;
  final String content;
  final String senderId;
  final String senderUsername;
  final DateTime timestamp;
  final int senderLevel;
  final String? senderAvatar;

  Message({
    required this.id,
    required this.content,
    required this.senderId,
    required this.senderUsername,
    required this.timestamp,
    this.senderLevel = 1,
    this.senderAvatar,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'].toString(),
      content: json['content'] ?? '',
      senderId: json['senderId']?.toString() ?? '',
      senderUsername: json['senderUsername'] ?? 'Unknown',
      timestamp: json['timestamp'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['timestamp'])
          : DateTime.now(),
      senderLevel: json['senderLevel'] ?? 1,
      senderAvatar: json['senderAvatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'senderId': senderId,
      'senderUsername': senderUsername,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'senderLevel': senderLevel,
      'senderAvatar': senderAvatar,
    };
  }
}

