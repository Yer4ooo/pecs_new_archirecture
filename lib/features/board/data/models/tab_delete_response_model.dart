import 'dart:convert';

TabDeleteResponseModel tabDeleteResponseModelFromJson(String str) {
  final jsonData = json.decode(str);
  return TabDeleteResponseModel.fromJson(jsonData);
}

String tabDeleteResponseModelToJson(TabDeleteResponseModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class TabDeleteResponseModel {
  String message;

  TabDeleteResponseModel({
    required this.message,
  });

  factory TabDeleteResponseModel.fromJson(Map<String, dynamic> json) => new TabDeleteResponseModel(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
