import 'dart:convert';

BoardUpdateRequestModel boardUpdateRequestModelFromJson(String str) {
  final jsonData = json.decode(str);
  return BoardUpdateRequestModel.fromJson(jsonData);
}

String boardUpdateRequestModelToJson(BoardUpdateRequestModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class BoardUpdateRequestModel {
  String name;
  bool private;
  String color;
  List<Sticker> stickers;

  BoardUpdateRequestModel({
    required this.name,
    required this.private,
    required this.color,
    required this.stickers,
  });

  factory BoardUpdateRequestModel.fromJson(Map<String, dynamic> json) =>
      new BoardUpdateRequestModel(
        name: json["name"],
        private: json["private"],
        color: json["color"],
        stickers: new List<Sticker>.from(
            json["stickers"].map((x) => Sticker.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "private": private,
        "color": color,
        "stickers": new List<dynamic>.from(stickers.map((x) => x.toJson())),
      };
}

class Sticker {
  int position;
  int stickerId;

  Sticker({
    required this.position,
    required this.stickerId,
  });

  factory Sticker.fromJson(Map<String, dynamic> json) => new Sticker(
        position: json["position"],
        stickerId: json["sticker_id"],
      );

  Map<String, dynamic> toJson() => {
        "position": position,
        "sticker_id": stickerId,
      };
}
