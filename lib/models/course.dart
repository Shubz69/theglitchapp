class Course {
  final String id;
  final String title;
  final String description;
  final double price;
  final String? imageUrl;
  final bool isFree;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.imageUrl,
  }) : isFree = price == 0;

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}

