import 'dart:convert';

BoardUpdateResponseModel boardUpdateResponseModelFromJson(String str) {
  final jsonData = json.decode(str);
  return BoardUpdateResponseModel.fromJson(jsonData);
}

String boardUpdateResponseModelToJson(BoardUpdateResponseModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class BoardUpdateResponseModel {
  String message;

  BoardUpdateResponseModel({
    required this.message,
  });

  factory BoardUpdateResponseModel.fromJson(Map<String, dynamic> json) =>
      BoardUpdateResponseModel(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}
