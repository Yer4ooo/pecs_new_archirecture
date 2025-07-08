// To parse this JSON data, do
//
//     final tabUpdateRequestModel = tabUpdateRequestModelFromJson(jsonString);

import 'dart:convert';

TabUpdateRequestModel tabUpdateRequestModelFromJson(String str) {
  final jsonData = json.decode(str);
  return TabUpdateRequestModel.fromJson(jsonData);
}

String tabUpdateRequestModelToJson(TabUpdateRequestModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class TabUpdateRequestModel {
  int tabId;
  String name;
  int strapsNum;
  String color;

  TabUpdateRequestModel({
    required this.tabId,
    required this.name,
    required this.strapsNum,
    required this.color,
  });

  factory TabUpdateRequestModel.fromJson(Map<String, dynamic> json) => new TabUpdateRequestModel(
    tabId: json["tab_id"],
    name: json["name"],
    strapsNum: json["straps_num"],
    color: json["color"],
  );

  Map<String, dynamic> toJson() => {
    "tab_id": tabId,
    "name": name,
    "straps_num": strapsNum,
    "color": color,
  };
}
