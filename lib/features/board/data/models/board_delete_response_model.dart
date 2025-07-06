import 'dart:convert';

BoardDeleteResponseModel boardDeleteResponseModelFromJson(String str) {
  final jsonData = json.decode(str);
  return BoardDeleteResponseModel.fromJson(jsonData);
}

String boardDeleteResponseModelToJson(BoardDeleteResponseModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class BoardDeleteResponseModel {
  String message;

  BoardDeleteResponseModel({
    required this.message,
  });

  factory BoardDeleteResponseModel.fromJson(Map<String, dynamic> json) =>
      BoardDeleteResponseModel(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}
