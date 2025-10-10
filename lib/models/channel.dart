class Channel {
  final String id;
  final String name;
  final String description;
  final String accessLevel;
  final int? minLevel;
  final int? courseId;
  final bool isLocked;
  final int memberCount;

  Channel({
    required this.id,
    required this.name,
    required this.description,
    required this.accessLevel,
    this.minLevel,
    this.courseId,
    this.isLocked = false,
    this.memberCount = 0,
  });

  bool get isReadOnly => accessLevel == 'readonly';

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      accessLevel: json['accessLevel'] ?? 'open',
      minLevel: json['minLevel'],
      courseId: json['courseId'],
      isLocked: json['isLocked'] ?? false,
      memberCount: json['memberCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'accessLevel': accessLevel,
      'minLevel': minLevel,
      'courseId': courseId,
      'isLocked': isLocked,
      'memberCount': memberCount,
    };
  }
}

