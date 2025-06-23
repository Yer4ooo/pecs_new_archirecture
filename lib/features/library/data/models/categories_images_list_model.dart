import 'dart:convert';

List<CategoriesImagesListModel> categoriesImagesListModelFromJson(String str) =>
    List<CategoriesImagesListModel>.from(
        json.decode(str).map((x) => CategoriesImagesListModel.fromJson(x)));

String categoriesImagesListModelToJson(List<CategoriesImagesListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoriesImagesListModel {
  int? id;
  String? name;
  String? imageUrl;
  int? folder;
  bool? public;
  int? creatorId;
  String? creatorName;

  CategoriesImagesListModel({
    this.id,
    this.name,
    this.imageUrl,
    this.folder,
    this.public,
    this.creatorId,
    this.creatorName,
  });

  factory CategoriesImagesListModel.fromJson(Map<String, dynamic> json) =>
      CategoriesImagesListModel(
        id: json["id"],
        name: json["name"],
        imageUrl: json["imageUrl"],
        folder: json["folder"],
        public: json["public"],
        creatorId: json["creator_id"],
        creatorName: json["creator_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imageUrl": imageUrl,
        "folder": folder,
        "public": public,
        "creator_id": creatorId,
        "creator_name": creatorName,
      };

  static List<CategoriesImagesListModel> fromList(List? list) {
    if (list == null) return [];
    return list.map((e) => CategoriesImagesListModel.fromJson(e)).toList();
  }
}
