import 'dart:convert';

BoardDetailsModel boardDetailsModelFromJson(String str) {
  final jsonData = json.decode(str);
  return BoardDetailsModel.fromJson(jsonData);
}

String boardDetailsModelToJson(BoardDetailsModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class BoardDetailsModel {
  Board board;

  BoardDetailsModel({
    required this.board,
  });

  factory BoardDetailsModel.fromJson(Map<String, dynamic> json) =>
      BoardDetailsModel(
        board: Board.fromJson(json["board"]),
      );

  Map<String, dynamic> toJson() => {
        "board": board.toJson(),
      };
}

class Board {
  int id;
  String name;
  int creator;
  String color;
  List<dynamic> stickers;
  List<Tab> tabs;

  Board({
    required this.id,
    required this.name,
    required this.creator,
    required this.color,
    required this.stickers,
    required this.tabs,
  });

  factory Board.fromJson(Map<String, dynamic> json) => Board(
        id: json["id"],
        name: json["name"],
        creator: json["creator"],
        color: json["color"],
        stickers: List<dynamic>.from(json["stickers"].map((x) => x)),
        tabs: List<Tab>.from(json["tabs"].map((x) => Tab.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "creator": creator,
        "color": color,
        "stickers": List<dynamic>.from(stickers.map((x) => x)),
        "tabs": List<dynamic>.from(tabs.map((x) => x.toJson())),
      };
}

class Tab {
  int id;
  String name;
  int strapsNum;
  String color;

  Tab({
    required this.id,
    required this.name,
    required this.strapsNum,
    required this.color,
  });

  factory Tab.fromJson(Map<String, dynamic> json) => Tab(
        id: json["id"],
        name: json["name"],
        strapsNum: json["straps_num"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "straps_num": strapsNum,
        "color": color,
      };
}
