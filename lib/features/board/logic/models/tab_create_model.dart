// To parse this JSON data, do
//
//     final tabCreateModel = tabCreateModelFromJson(jsonString);

import 'dart:convert';

TabCreateModel tabCreateModelFromJson(String str) {
  final jsonData = json.decode(str);
  return TabCreateModel.fromJson(jsonData);
}

String tabCreateModelToJson(TabCreateModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class TabCreateModel {
  int boardId;
  String name;
  int strapsNum;
  String color;

  TabCreateModel({
    required this.boardId,
    required this.name,
    required this.strapsNum,
    required this.color,
  });

  factory TabCreateModel.fromJson(Map<String, dynamic> json) => new TabCreateModel(
    boardId: json["board_id"],
    name: json["name"],
    strapsNum: json["straps_num"],
    color: json["color"],
  );

  Map<String, dynamic> toJson() => {
    "board_id": boardId,
    "name": name,
    "straps_num": strapsNum,
    "color": color,
  };
}
