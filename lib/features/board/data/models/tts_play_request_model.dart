import 'dart:convert';

TtsPlayRequestModel ttsPlayRequestModelFromJson(String str) {
  final jsonData = json.decode(str);
  return TtsPlayRequestModel.fromJson(jsonData);
}

String ttsPlayRequestModelToJson(TtsPlayRequestModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class TtsPlayRequestModel {
  List<int> imageIds;
  String voiceLanguage;

  TtsPlayRequestModel({
    required this.imageIds,
    required this.voiceLanguage,
  });

  factory TtsPlayRequestModel.fromJson(Map<String, dynamic> json) =>
      TtsPlayRequestModel(
        imageIds: List<int>.from(json["image_ids"].map((x) => x)),
        voiceLanguage: json["voice_language"],
      );

  Map<String, dynamic> toJson() => {
        "image_ids": List<dynamic>.from(imageIds.map((x) => x)),
        "voice_language": voiceLanguage,
      };
}
