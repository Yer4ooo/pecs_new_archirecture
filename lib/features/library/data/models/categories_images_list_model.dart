import 'dart:convert';

List<CategoriesImagesListModel> categoriesImagesListModelFromJson(String str) =>
    List<CategoriesImagesListModel>.from(
        json.decode(str).map((x) => CategoriesImagesListModel.fromJson(x)));

String categoriesImagesListModelToJson(List<CategoriesImagesListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoriesImagesListModel {
  int? id;
  String? name;
  String? label_en;
  String? label_ru;
  String? label_kk;
  String? imageUrl;
  bool? public;
  int? creatorId;
  String? creatorName;

  CategoriesImagesListModel({
    this.id,
    this.name,
    this.imageUrl,
    this.public,
    this.creatorId,
    this.creatorName,
    this.label_en,
    this.label_ru,
    this.label_kk,
  });

  factory CategoriesImagesListModel.fromJson(Map<String, dynamic> json) =>
      CategoriesImagesListModel(
        id: json["id"],
        name: json["name"],
        label_en: json["label_en"],
        label_ru: json["label_ru"],
        label_kk: json["label_kk"],
        imageUrl: json["imageUrl"],
        public: json["public"],
        creatorId: json["creator_id"],
        creatorName: json["creator_name"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "label_en": label_en,
    "label_ru": label_ru,
    "label_kk": label_kk,
    "imageUrl": imageUrl,
    "public": public,
    "creator_id": creatorId,
    "creator_name": creatorName,
  };
  String getLocalizedName(String locale) {
    switch (locale) {
      case 'kk':
        return label_kk?.isNotEmpty == true ? label_kk! : label_en ?? name ?? '';
      case 'ru':
        return label_ru?.isNotEmpty == true ? label_ru! : label_en ?? name ?? '';
      case 'en':
      default:
        return label_en ?? name ?? '';
    }
  }
  static List<CategoriesImagesListModel> fromList(List? list) {
    if (list == null) return [];
    return list.map((e) => CategoriesImagesListModel.fromJson(e)).toList();
  }
}
