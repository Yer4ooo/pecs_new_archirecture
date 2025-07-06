class StickerModel {
  final int id;
  final String name;
  final String imageUrl;

  StickerModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory StickerModel.fromJson(Map<String, dynamic> json) {
    return StickerModel(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
    };
  }
}
