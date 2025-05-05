import 'dart:convert';

BoardModel boardModelFromJson(String str) => BoardModel.fromJson(json.decode(str));

String boardModelToJson(BoardModel data) => json.encode(data.toJson());

class BoardModel {
  List<Board>? boards;
  bool? isCr;
  bool? isCg;

  BoardModel({
    this.boards,
    this.isCr,
    this.isCg,
  });

  BoardModel copyWith({
    List<Board>? boards,
    bool? isCr,
    bool? isCg,
  }) =>
      BoardModel(
        boards: boards ?? this.boards,
        isCr: isCr ?? this.isCr,
        isCg: isCg ?? this.isCg,
      );

  factory BoardModel.fromJson(Map<String, dynamic> json) => BoardModel(
        boards: json["boards"] == null
            ? null
            : List<Board>.from(json["boards"].map((x) => Board.fromJson(x))),
        isCr: json["is_cr"],
        isCg: json["is_cg"],
      );

  Map<String, dynamic> toJson() => {
        "boards": boards == null ? null : List<dynamic>.from(boards!.map((x) => x.toJson())),
        "is_cr": isCr,
        "is_cg": isCg,
      };
}

class Board {
  int? id;
  String? name;
  int? creator;
  List<AccessUser>? accessUsers;
  String? color;
  bool? private;

  Board({
    this.id,
    this.name,
    this.creator,
    this.accessUsers,
    this.color,
    this.private,
  });

  Board copyWith({
    int? id,
    String? name,
    int? creator,
    List<AccessUser>? accessUsers,
    String? color,
    bool? private,
  }) =>
      Board(
        id: id ?? this.id,
        name: name ?? this.name,
        creator: creator ?? this.creator,
        accessUsers: accessUsers ?? this.accessUsers,
        color: color ?? this.color,
        private: private ?? this.private,
      );

  factory Board.fromJson(Map<String, dynamic> json) => Board(
        id: json["id"],
        name: json["name"],
        creator: json["creator"],
        accessUsers: json["access_users"] == null
            ? null
            : List<AccessUser>.from(json["access_users"].map((x) => AccessUser.fromJson(x))),
        color: json["color"],
        private: json["private"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "creator": creator,
        "access_users":
            accessUsers == null ? null : List<dynamic>.from(accessUsers!.map((x) => x.toJson())),
        "color": color,
        "private": private,
      };
        static List<Board> fromList(List? list) {
    if (list == null) return [];
    return list
        .map((e) => Board.fromJson(e))
        .toList();
  }

}

class AccessUser {
  int? id;
  String? username;

  AccessUser({
    this.id,
    this.username,
  });

  AccessUser copyWith({
    int? id,
    String? username,
  }) =>
      AccessUser(
        id: id ?? this.id,
        username: username ?? this.username,
      );

  factory AccessUser.fromJson(Map<String, dynamic> json) => AccessUser(
        id: json["id"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
      };
}
