import 'dart:convert';

CategoriesImagesCreateResponseModel categoriesImagesCreateResponseModelFromJson(
        String str) =>
    CategoriesImagesCreateResponseModel.fromJson(json.decode(str));

String categoriesImagesCreateResponseModelToJson(
        CategoriesImagesCreateResponseModel data) =>
    json.encode(data.toJson());

class CategoriesImagesCreateResponseModel {
  int id;
  String name;
  String imageUrl;
  int categoryId;

  CategoriesImagesCreateResponseModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.categoryId,
  });

  factory CategoriesImagesCreateResponseModel.fromJson(
          Map<String, dynamic> json) =>
      CategoriesImagesCreateResponseModel(
        id: json["id"],
        name: json["name"],
        imageUrl: json["imageUrl"],
        categoryId: json["categoryId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imageUrl": imageUrl,
        "categoryId": categoryId,
      };
}
