import 'dart:convert';

CategoriesImagesCreateRequestModel categoriesImagesCreateRequestModelFromJson(
        String str) =>
    CategoriesImagesCreateRequestModel.fromJson(json.decode(str));

String categoriesImagesCreateRequestModelToJson(
        CategoriesImagesCreateRequestModel data) =>
    json.encode(data.toJson());

class CategoriesImagesCreateRequestModel {
  int id;
  String name;
  String imageUrl;

  CategoriesImagesCreateRequestModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory CategoriesImagesCreateRequestModel.fromJson(
          Map<String, dynamic> json) =>
      CategoriesImagesCreateRequestModel(
        id: json['id'],
        name: json["name"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imageUrl": imageUrl,
      };
}
