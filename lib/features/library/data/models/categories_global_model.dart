class CategoriesGlobalModel {
  final int count;
  final String? next;
  final String? prev;
  final List<BaseItem> items;

  CategoriesGlobalModel({
    required this.count,
    this.next,
    this.prev,
    required this.items,
  });

  factory CategoriesGlobalModel.fromJson(Map<String, dynamic> json) {
    return CategoriesGlobalModel(
      count: json['count'] ?? 0,
      next: json['next'],
      prev: json['prev'],
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => BaseItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'next': next,
      'prev': prev,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

// Change BaseItem to sealed class
sealed class BaseItem {
  final int id;
  final String name;
  final bool public;
  final String type;

  BaseItem({
    required this.id,
    required this.name,
    required this.public,
    required this.type,
  });

  factory BaseItem.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;

    switch (type) {
      case 'category':
        return CategoryItem.fromJson(json);
      case 'image':
        return ImageItem.fromJson(json);
      default:
        throw Exception('Unknown item type: $type');
    }
  }

  Map<String, dynamic> toJson();
}

extension BaseItemExtension on BaseItem {
  String get imageUrl {
    return switch (this) {
      CategoryItem category => category.imageUrl,
      ImageItem image => image.imageUrl,
    };
  }
}

class CategoryItem extends BaseItem {
  final bool verified;
  final String nameEn;
  final String nameRu;
  final String nameKk;
  final String? translationModel;
  final int creator;
  final String creatorFirstName;
  final String creatorLastName;
  final String imageUrl;
  final DateTime createdAt;

  CategoryItem({
    required super.id,
    required super.name,
    required super.public,
    required this.verified,
    required this.nameEn,
    required this.nameRu,
    required this.nameKk,
    this.translationModel,
    required this.creator,
    required this.creatorFirstName,
    required this.creatorLastName,
    required this.imageUrl,
    required this.createdAt,
  }) : super(type: 'category');

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      public: json['public'] ?? false,
      verified: json['verified'] ?? false,
      nameEn: json['name_en'] ?? '',
      nameRu: json['name_ru'] ?? '',
      nameKk: json['name_kk'] ?? '',
      translationModel: json['translation_model'],
      creator: json['creator'] ?? 0,
      creatorFirstName: json['creator_first_name'] ?? '',
      creatorLastName: json['creator_last_name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'public': public,
      'verified': verified,
      'name_en': nameEn,
      'name_ru': nameRu,
      'name_kk': nameKk,
      'translation_model': translationModel,
      'creator': creator,
      'creator_first_name': creatorFirstName,
      'creator_last_name': creatorLastName,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'type': type,
    };
  }
}

class ImageItem extends BaseItem {
  final String labelEn;
  final String labelRu;
  final String labelKk;
  final String imageUrl;
  final int creatorId;
  final String creatorName;

  ImageItem({
    required super.id,
    required super.name,
    required super.public,
    required this.labelEn,
    required this.labelRu,
    required this.labelKk,
    required this.imageUrl,
    required this.creatorId,
    required this.creatorName,
  }) : super(type: 'image');

  factory ImageItem.fromJson(Map<String, dynamic> json) {
    return ImageItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      public: json['public'] ?? false,
      labelEn: json['label_en'] ?? '',
      labelRu: json['label_ru'] ?? '',
      labelKk: json['label_kk'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      creatorId: json['creator_id'] ?? 0,
      creatorName: json['creator_name'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'public': public,
      'label_en': labelEn,
      'label_ru': labelRu,
      'label_kk': labelKk,
      'imageUrl': imageUrl,
      'creator_id': creatorId,
      'creator_name': creatorName,
      'type': type,
    };
  }
}

extension CategoriesResponseExtension on CategoriesGlobalModel {
  List<CategoryItem> get categories => items.whereType<CategoryItem>().toList();

  List<ImageItem> get images => items.whereType<ImageItem>().toList();

  bool get hasNextPage => next != null;
  bool get hasPrevPage => prev != null;
}
