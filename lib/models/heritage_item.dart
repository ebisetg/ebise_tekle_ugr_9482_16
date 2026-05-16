class HeritageItem {
  final String id;
  final String title;
  final String name;
  final String country;
  final String category;
  final String description;
  final String? imageUrl;

  HeritageItem({
    required this.id,
    required this.title,
    required this.name,
    required this.country,
    required this.category,
    required this.description,
    this.imageUrl,
  });

  factory HeritageItem.fromJson(Map<String, dynamic> json) {
    return HeritageItem(
      id: json['id'] as String,
      title: json['title'] as String,
      name: json['name'] as String,
      country: json['country'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'category': category,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  HeritageItem copyWith({
    String? id,
    String? title,
    String? name,
    String? country,
    String? category,
    String? description,
    String? imageUrl,
  }) {
    return HeritageItem(
      id: id ?? this.id,
      title: title ?? this.title,
      name: name ?? this.name,
      country: country ?? this.country,
      category: category ?? this.category,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}