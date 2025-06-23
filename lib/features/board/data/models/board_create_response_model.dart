import 'dart:convert';

BoardCreateResponseModel boardCreateResponseModelFromJson(String str) {
  final jsonData = json.decode(str);
  return BoardCreateResponseModel.fromJson(jsonData);
}

String boardCreateResponseModelToJson(BoardCreateResponseModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class BoardCreateResponseModel {
  String message;

  BoardCreateResponseModel({
    required this.message,
  });

  factory BoardCreateResponseModel.fromJson(Map<String, dynamic> json) =>
      new BoardCreateResponseModel(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}
