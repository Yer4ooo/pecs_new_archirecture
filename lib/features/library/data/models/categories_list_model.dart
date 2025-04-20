import 'dart:convert';

CateoriesListModel cateoriesListModelFromJson(String str) => CateoriesListModel.fromJson(json.decode(str));

String cateoriesListModelToJson(CateoriesListModel data) => json.encode(data.toJson());

class CateoriesListModel {
  int? id;
  String? name;
  String? image;
  bool? public;
  int? creator;
  String? creatorName;
  String? imageUrl;
  DateTime? createdAt;

  CateoriesListModel({
    this.id,
    this.name,
    this.image,
    this.public,
    this.creator,
    this.creatorName,
    this.imageUrl,
    this.createdAt,
  });

  CateoriesListModel copyWith({
    int? id,
    String? name,
    String? image,
    bool? public,
    int? creator,
    String? creatorName,
    String? imageUrl,
    DateTime? createdAt,
  }) => CateoriesListModel(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image ?? this.image,
        public: public ?? this.public,
        creator: creator ?? this.creator,
        creatorName: creatorName ?? this.creatorName,
        imageUrl: imageUrl ?? this.imageUrl,
        createdAt: createdAt ?? this.createdAt,
      );

  factory CateoriesListModel.fromJson(Map<String, dynamic> json) => CateoriesListModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        public: json["public"],
        creator: json["creator"],
        creatorName: json["creator_name"],
        imageUrl: json["image_url"],
        createdAt: json["created_at"] != null ? DateTime.tryParse(json["created_at"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "public": public,
        "creator": creator,
        "creator_name": creatorName,
        "image_url": imageUrl,
        "created_at": createdAt?.toIso8601String(),
      };
                static List<CateoriesListModel> fromList(List? list) {
    if (list == null) return [];
    return list.map((e) => CateoriesListModel.fromJson(e)).toList();
  }
}
