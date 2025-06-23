import 'dart:convert';

BoardModel boardModelFromJson(String str) {
  final jsonData = json.decode(str);
  return BoardModel.fromJson(jsonData);
}

String boardModelToJson(BoardModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class BoardModel {
  List<Board> boards;

  BoardModel({
    required this.boards,
  });

  factory BoardModel.fromJson(Map<String, dynamic> json) => BoardModel(
        boards: List<Board>.from(json["boards"].map((x) => Board.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "boards": List<dynamic>.from(boards.map((x) => x.toJson())),
      };
}

class Board {
  int id;
  String name;
  int creator;
  String color;
  List<StickerElement> stickers;

  Board({
    required this.id,
    required this.name,
    required this.creator,
    required this.color,
    required this.stickers,
  });

  factory Board.fromJson(Map<String, dynamic> json) => Board(
        id: json["id"],
        name: json["name"],
        creator: json["creator"],
        color: json["color"],
        stickers: List<StickerElement>.from(
            json["stickers"].map((x) => StickerElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "creator": creator,
        "color": color,
        "stickers": List<dynamic>.from(stickers.map((x) => x.toJson())),
      };
  int? getIndexByPosition(int position) {
    for (int i = 0; i < stickers.length; i++) {
      if (stickers[i].position == position) {
        return i;
      }
    }
    return null;
  }

  List<int> getPositions() {
    return stickers.map((sticker) => sticker.position).toList();
  }
}

class StickerElement {
  int position;
  StickerSticker sticker;

  StickerElement({
    required this.position,
    required this.sticker,
  });

  factory StickerElement.fromJson(Map<String, dynamic> json) => StickerElement(
        position: json["position"],
        sticker: StickerSticker.fromJson(json["sticker"]),
      );

  Map<String, dynamic> toJson() => {
        "position": position,
        "sticker": sticker.toJson(),
      };
}

class StickerSticker {
  int id;
  String name;
  String imageUrl;

  StickerSticker({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory StickerSticker.fromJson(Map<String, dynamic> json) => StickerSticker(
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
