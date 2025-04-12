import 'dart:convert';

CategoriesCreateRequestModel CategoriesCreateRequestModelFromJson(String str) =>
    CategoriesCreateRequestModel.fromJson(json.decode(str));

String CategoriesCreateRequestModelToJson(CategoriesCreateRequestModel data) => json.encode(data.toJson());

class CategoriesCreateRequestModel {
  String name;
  String imageUrl;

  CategoriesCreateRequestModel({
    required this.name,
    required this.imageUrl,
  });

  factory CategoriesCreateRequestModel.fromJson(Map<String, dynamic> json) => CategoriesCreateRequestModel(
        name: json["name"],
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image_url": imageUrl,
      };
}
