import 'dart:convert';

TabCreateResponseModel tabCreateResponseModelFromJson(String str) {
  final jsonData = json.decode(str);
  return TabCreateResponseModel.fromJson(jsonData);
}

String tabCreateResponseModelToJson(TabCreateResponseModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class TabCreateResponseModel {
  String message;
  Tab tab;

  TabCreateResponseModel({
    required this.message,
    required this.tab,
  });

  factory TabCreateResponseModel.fromJson(Map<String, dynamic> json) =>
      new TabCreateResponseModel(
        message: json["message"],
        tab: Tab.fromJson(json["tab"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "tab": tab.toJson(),
      };
}

class Tab {
  int id;
  String name;
  int strapsNum;
  int board;
  String color;

  Tab({
    required this.id,
    required this.name,
    required this.strapsNum,
    required this.board,
    required this.color,
  });

  factory Tab.fromJson(Map<String, dynamic> json) => new Tab(
        id: json["id"],
        name: json["name"],
        strapsNum: json["straps_num"],
        board: json["board"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "straps_num": strapsNum,
        "board": board,
        "color": color,
      };
}
