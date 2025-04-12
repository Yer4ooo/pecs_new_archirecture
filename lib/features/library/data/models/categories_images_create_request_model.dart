import 'dart:convert';

CateoriesImagesCreateRequestModel cateoriesImagesCreateRequestModelFromJson(String str) =>
    CateoriesImagesCreateRequestModel.fromJson(json.decode(str));

String cateoriesImagesCreateRequestModelToJson(CateoriesImagesCreateRequestModel data) => json.encode(data.toJson());

class CateoriesImagesCreateRequestModel {
  int id;
  String name;
  String imageUrl;

  CateoriesImagesCreateRequestModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory CateoriesImagesCreateRequestModel.fromJson(Map<String, dynamic> json) => CateoriesImagesCreateRequestModel(
        id: json['id'],
        name: json["name"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id":id,
        "name": name,
        "imageUrl": imageUrl,
      };
}
