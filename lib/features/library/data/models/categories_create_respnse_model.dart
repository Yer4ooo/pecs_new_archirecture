import 'dart:convert';

CateoriesCreateResponseModel cateoriesCreateResponseModelFromJson(String str) => CateoriesCreateResponseModel.fromJson(json.decode(str));

String cateoriesCreateResponseModelToJson(CateoriesCreateResponseModel data) => json.encode(data.toJson());

class CateoriesCreateResponseModel {
    int id;
    String name;
    String imageUrl;

    CateoriesCreateResponseModel({
        required this.id,
        required this.name,
        required this.imageUrl,
    });

    factory CateoriesCreateResponseModel.fromJson(Map<String, dynamic> json) => CateoriesCreateResponseModel(
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
