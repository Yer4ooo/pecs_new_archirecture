import 'dart:convert';

List<CateoriesImagesListModel> cateoriesImagesListModelFromJson(String str) => List<CateoriesImagesListModel>.from(json.decode(str).map((x) => CateoriesImagesListModel.fromJson(x)));

String cateoriesImagesListModelToJson(List<CateoriesImagesListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CateoriesImagesListModel {
    int id;
    String name;
    String imageUrl;
    int folder;
    bool public;
    String creatorId;
    String creatorName;

    CateoriesImagesListModel({
        required this.id,
        required this.name,
        required this.imageUrl,
        required this.folder,
        required this.public,
        required this.creatorId,
        required this.creatorName,
    });

    factory CateoriesImagesListModel.fromJson(Map<String, dynamic> json) => CateoriesImagesListModel(
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
          static List<CateoriesImagesListModel> fromList(List? list) {
    if (list == null) return [];
    return list.map((e) => CateoriesImagesListModel.fromJson(e)).toList();
  }
}
