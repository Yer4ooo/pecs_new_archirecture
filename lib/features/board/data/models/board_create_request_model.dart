// To parse this JSON data, do
//
//     final boardCreateRequestModel = boardCreateRequestModelFromJson(jsonString);

import 'dart:convert';

import 'package:pecs_new_arch/features/board/data/models/board_update_request_model.dart';

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
  List<Sticker> stickers;

  BoardCreateRequestModel({
    required this.name,
    required this.private,
    required this.color,
    required this.stickers,
  });

  factory BoardCreateRequestModel.fromJson(Map<String, dynamic> json) =>
      new BoardCreateRequestModel(
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
