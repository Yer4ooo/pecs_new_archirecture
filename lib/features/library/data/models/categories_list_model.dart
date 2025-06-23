class CategoriesListModel {
  final int count;
  final String? next;
  final String? prev;
  final List<CategoryItem> items;

  CategoriesListModel({
    required this.count,
    this.next,
    this.prev,
    required this.items,
  });

  factory CategoriesListModel.fromJson(Map<String, dynamic> json) {
    return CategoriesListModel(
      count: json['count'] ?? 0,
      next: json['next'],
      prev: json['prev'],
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => CategoryItem.fromJson(item))
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

// Category item model
class CategoryItem {
  final int id;
  final String name;
  final bool public;
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
    required this.id,
    required this.name,
    required this.public,
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
  });

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
    };
  }
}

extension CategoriesGlobalModelExtension on CategoriesListModel {
  bool get hasNextPage => next != null;
  bool get hasPrevPage => prev != null;

  List<String> getLocalizedNames(String locale) {
    return items.map((item) {
      switch (locale) {
        case 'ru':
          return item.nameRu;
        case 'kk':
          return item.nameKk;
        case 'en':
        default:
          return item.nameEn;
      }
    }).toList();
  }
}

// Extension for CategoryItem
extension CategoryItemExtension on CategoryItem {
  String getLocalizedName(String locale) {
    switch (locale) {
      case 'ru':
        return nameRu;
      case 'kk':
        return nameKk;
      case 'en':
      default:
        return nameEn;
    }
  }

  String get creatorFullName => '$creatorFirstName $creatorLastName';
}
