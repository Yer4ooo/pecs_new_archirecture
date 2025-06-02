import 'dart:convert';

BoardCreateModel boardCreateModelFromJson(String str) {
  final jsonData = json.decode(str);
  return BoardCreateModel.fromJson(jsonData);
}

String boardCreateModelToJson(BoardCreateModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class BoardCreateModel {
  String? name;
  bool? private;
  String? color;

  BoardCreateModel({
    this.name,
    this.private,
    this.color,
  });

  factory BoardCreateModel.fromJson(Map<String, dynamic> json) => BoardCreateModel(
    name: json["name"] ?? "Default Name",
    private: json["private"] ?? false,
    color: json["color"] ?? "#FFFFFF",
  );


  Map<String, dynamic> toJson() => {
    "name": name,
    "private": private,
    "color": color,
  };
}
