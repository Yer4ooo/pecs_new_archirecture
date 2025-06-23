import 'dart:convert';

TabCreateRequestModel tabCreateRequestModelFromJson(String str) {
  final jsonData = json.decode(str);
  return TabCreateRequestModel.fromJson(jsonData);
}

String tabCreateRequestModelToJson(TabCreateRequestModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class TabCreateRequestModel {
  int boardId;
  String name;
  int strapsNum;
  String color;

  TabCreateRequestModel({
    required this.boardId,
    required this.name,
    required this.strapsNum,
    required this.color,
  });

  factory TabCreateRequestModel.fromJson(Map<String, dynamic> json) =>
      TabCreateRequestModel(
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
