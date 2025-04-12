import 'dart:convert';

CateoriesImagesCreateResponseModel cateoriesImagesCreateResponseModelFromJson(String str) => CateoriesImagesCreateResponseModel.fromJson(json.decode(str));

String cateoriesImagesCreateResponseModelToJson(CateoriesImagesCreateResponseModel data) => json.encode(data.toJson());

class CateoriesImagesCreateResponseModel {
    int id;
    String name;
    String imageUrl;
    int categoryId;

    CateoriesImagesCreateResponseModel({
        required this.id,
        required this.name,
        required this.imageUrl,
        required this.categoryId,
    });

    factory CateoriesImagesCreateResponseModel.fromJson(Map<String, dynamic> json) => CateoriesImagesCreateResponseModel(
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
