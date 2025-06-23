// To parse this JSON data, do
//
//     final boardsTabsResponseModel = boardsTabsResponseModelFromJson(jsonString);

import 'dart:convert';

BoardsTabsResponseModel boardsTabsResponseModelFromJson(String str) {
  try {
    final jsonData = json.decode(str);
    if (jsonData == null || jsonData is! Map<String, dynamic>) {
      return BoardsTabsResponseModel(images: []);
    }
    return BoardsTabsResponseModel.fromJson(jsonData);
  } catch (e) {
    print('JSON parsing error: $e');
    return BoardsTabsResponseModel(images: []);
  }
}

String boardsTabsResponseModelToJson(BoardsTabsResponseModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class BoardsTabsResponseModel {
  List<ImageElement> images;

  BoardsTabsResponseModel({
    required this.images,
  });

  factory BoardsTabsResponseModel.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return BoardsTabsResponseModel(images: []);
    }

    return BoardsTabsResponseModel(
      images: (json["images"] != null && json["images"] is List)
          ? List<ImageElement>.from(json["images"].map((x) =>
      x != null ? ImageElement.fromJson(x) : null).where((x) => x != null))
          : <ImageElement>[],
    );
  }

  Map<String, dynamic> toJson() => {
    "images": List<dynamic>.from(images.map((x) => x.toJson())),
  };
}

class ImageElement {
  int id;
  ImageImage image;
  double positionX;
  double positionY;
  int tab;

  ImageElement({
    required this.id,
    required this.image,
    required this.positionX,
    required this.positionY,
    required this.tab,
  });

  factory ImageElement.fromJson(Map<String, dynamic> json) => ImageElement(
    id: json["id"] ?? 0,
    image: ImageImage.fromJson(json["image"] ?? {}),
    positionX: (json["position_x"] ?? 0.0).toDouble(),
    positionY: (json["position_y"] ?? 0.0).toDouble(),
    tab: json["tab"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image.toJson(),
    "position_x": positionX,
    "position_y": positionY,
    "tab": tab,
  };
}

class ImageImage {
  int id;
  String name;
  String labelEn;
  String labelRu;
  String labelKk;
  String imageUrl;
  bool public;
  int creatorId;
  String creatorName;

  ImageImage({
    required this.id,
    required this.name,
    required this.labelEn,
    required this.labelRu,
    required this.labelKk,
    required this.imageUrl,
    required this.public,
    required this.creatorId,
    required this.creatorName,
  });

  factory ImageImage.fromJson(Map<String, dynamic> json) => ImageImage(
    id: json["id"] ?? 0,
    name: json["name"] ?? "",
    labelEn: json["label_en"] ?? "",
    labelRu: json["label_ru"] ?? "",
    labelKk: json["label_kk"] ?? "",
    imageUrl: json["imageUrl"] ?? "",
    public: json["public"] ?? false,
    creatorId: json["creator_id"] ?? 0,
    creatorName: json["creator_name"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "label_en": labelEn,
    "label_ru": labelRu,
    "label_kk": labelKk,
    "imageUrl": imageUrl,
    "public": public,
    "creator_id": creatorId,
    "creator_name": creatorName,
  };
}