class Channel {
  final String id;
  final String name;
  final String description;
  final String accessLevel;
  final int? minLevel;
  final int? courseId;

  Channel({
    required this.id,
    required this.name,
    required this.description,
    required this.accessLevel,
    this.minLevel,
    this.courseId,
  });

  bool get isReadOnly => accessLevel == 'readonly';
  bool get isLocked => accessLevel == 'level' || accessLevel == 'course' || accessLevel == 'admin-only';

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      accessLevel: json['accessLevel'] ?? 'open',
      minLevel: json['minLevel'],
      courseId: json['courseId'],
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
    };
  }
}

