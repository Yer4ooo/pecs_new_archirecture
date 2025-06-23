import 'dart:convert';

BoardCreateRequestModel boardCreateRequestModelFromJson(String str) {
  final jsonData = json.decode(str);
  return BoardCreateRequestModel.fromJson(jsonData);
}

String boardCreateRequestModelToJson(BoardCreateRequestModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class BoardCreateRequestModel {
  String name;
  bool private;
  String color;

  BoardCreateRequestModel({
    required this.name,
    required this.private,
    required this.color,
  });

  factory BoardCreateRequestModel.fromJson(Map<String, dynamic> json) =>
      BoardCreateRequestModel(
        name: json["name"],
        private: json["private"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "private": private,
        "color": color,
      };
}
