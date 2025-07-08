import 'dart:convert';

CategoriesCreateResponseModel categoriesCreateResponseModelFromJson(String str) {
  final jsonData = json.decode(str);
  return CategoriesCreateResponseModel.fromJson(jsonData);
}

String categoriesCreateResponseModelToJson(CategoriesCreateResponseModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class CategoriesCreateResponseModel {
  int id;
  String name;
  bool public;
  bool verified;
  String nameEn;
  String nameRu;
  String nameKk;
  String translationModel;
  int creator;
  String creatorFirstName;
  String creatorLastName;
  String imageUrl;
  String createdAt;

  CategoriesCreateResponseModel({
    required this.id,
    required this.name,
    required this.public,
    required this.verified,
    required this.nameEn,
    required this.nameRu,
    required this.nameKk,
    required this.translationModel,
    required this.creator,
    required this.creatorFirstName,
    required this.creatorLastName,
    required this.imageUrl,
    required this.createdAt,
  });

  factory CategoriesCreateResponseModel.fromJson(Map<String, dynamic> json) => new CategoriesCreateResponseModel(
    id: json["id"],
    name: json["name"],
    public: json["public"],
    verified: json["verified"],
    nameEn: json["name_en"],
    nameRu: json["name_ru"],
    nameKk: json["name_kk"],
    translationModel: json["translation_model"],
    creator: json["creator"],
    creatorFirstName: json["creator_first_name"],
    creatorLastName: json["creator_last_name"],
    imageUrl: json["image_url"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "public": public,
    "verified": verified,
    "name_en": nameEn,
    "name_ru": nameRu,
    "name_kk": nameKk,
    "translation_model": translationModel,
    "creator": creator,
    "creator_first_name": creatorFirstName,
    "creator_last_name": creatorLastName,
    "image_url": imageUrl,
    "created_at": createdAt,
  };
}
