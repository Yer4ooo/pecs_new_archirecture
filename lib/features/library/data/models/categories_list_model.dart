import 'dart:convert';

List<CateoriesListModel> cateoriesListModelFromJson(String str) => List<CateoriesListModel>.from(json.decode(str).map((x) => CateoriesListModel.fromJson(x)));

String cateoriesListModelToJson(List<CateoriesListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CateoriesListModel {
    int id;
    String name;
    String imageUrl;

    CateoriesListModel({
        required this.id,
        required this.name,
        required this.imageUrl,
    });

    factory CateoriesListModel.fromJson(Map<String, dynamic> json) => CateoriesListModel(
        id: json["id"],
        name: json["name"],
        imageUrl: json["imageUrl"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imageUrl": imageUrl,
    };
      static List<CateoriesListModel> fromList(List? list) {
    if (list == null) return [];
    return list.map((e) => CateoriesListModel.fromJson(e)).toList();
  }
}
