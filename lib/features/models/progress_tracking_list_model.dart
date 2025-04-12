import 'dart:convert';

ProgressTrackingListModel progressTrackingListModelFromJson(String str) => ProgressTrackingListModel.fromJson(json.decode(str));

String progressTrackingListModelToJson(ProgressTrackingListModel data) => json.encode(data.toJson());

class ProgressTrackingListModel {
    List<History> histories;
    bool isRecipient;
    List<String> boardNames;
    List<int> boardRepresentation;

    ProgressTrackingListModel({
        required this.histories,
        required this.isRecipient,
        required this.boardNames,
        required this.boardRepresentation,
    });

    factory ProgressTrackingListModel.fromJson(Map<String, dynamic> json) => ProgressTrackingListModel(
        histories: List<History>.from(json["histories"].map((x) => History.fromJson(x))),
        isRecipient: json["is_recipient"],
        boardNames: List<String>.from(json["board_names"].map((x) => x)),
        boardRepresentation: List<int>.from(json["board_representation"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "histories": List<dynamic>.from(histories.map((x) => x.toJson())),
        "is_recipient": isRecipient,
        "board_names": List<dynamic>.from(boardNames.map((x) => x)),
        "board_representation": List<dynamic>.from(boardRepresentation.map((x) => x)),
    };
}

class History {
    History();

    factory History.fromJson(Map<String, dynamic> json) => History(
    );

    Map<String, dynamic> toJson() => {
    };
}
