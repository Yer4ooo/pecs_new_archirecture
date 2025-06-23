import 'dart:convert';

CategoriesCreateResponseModel categoriesCreateResponseModelFromJson(
        String str) =>
    CategoriesCreateResponseModel.fromJson(json.decode(str));

String categoriesCreateResponseModelToJson(
        CategoriesCreateResponseModel data) =>
    json.encode(data.toJson());

class CategoriesCreateResponseModel {
  int id;
  String name;
  String imageUrl;

  CategoriesCreateResponseModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory CategoriesCreateResponseModel.fromJson(Map<String, dynamic> json) =>
      CategoriesCreateResponseModel(
        id: json["id"],
        name: json["name"],
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image_url": imageUrl,
      };
}
