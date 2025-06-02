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

  factory BoardDetailsModel.fromJson(Map<String, dynamic> json) => new BoardDetailsModel(
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
  List<AccessUser> accessUsers;
  String color;
  bool private;
  List<Tab> tabs;

  Board({
    required this.id,
    required this.name,
    required this.creator,
    required this.accessUsers,
    required this.color,
    required this.private,
    required this.tabs,
  });

  factory Board.fromJson(Map<String, dynamic> json) => new Board(
    id: json["id"],
    name: json["name"],
    creator: json["creator"],
    accessUsers: new List<AccessUser>.from(json["access_users"].map((x) => AccessUser.fromJson(x))),
    color: json["color"],
    private: json["private"],
    tabs: new List<Tab>.from(json["tabs"].map((x) => Tab.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "creator": creator,
    "access_users": new List<dynamic>.from(accessUsers.map((x) => x.toJson())),
    "color": color,
    "private": private,
    "tabs": new List<dynamic>.from(tabs.map((x) => x.toJson())),
  };
}

class AccessUser {
  int id;
  String username;

  AccessUser({
    required this.id,
    required this.username,
  });

  factory AccessUser.fromJson(Map<String, dynamic> json) => new AccessUser(
    id: json["id"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
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

  factory Tab.fromJson(Map<String, dynamic> json) => new Tab(
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