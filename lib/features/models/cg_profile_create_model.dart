import 'dart:convert';

CgProfileCreateModel cgProfileCreateModelFromJson(String str) => CgProfileCreateModel.fromJson(json.decode(str));

String cgProfileCreateModelToJson(CgProfileCreateModel data) => json.encode(data.toJson());

class CgProfileCreateModel {
    String d1;
    String d2;
    String d3;
    String d4;
    String d5;
    String d6;

    CgProfileCreateModel({
        required this.d1,
        required this.d2,
        required this.d3,
        required this.d4,
        required this.d5,
        required this.d6,
    });

    factory CgProfileCreateModel.fromJson(Map<String, dynamic> json) => CgProfileCreateModel(
        d1: json["d1"],
        d2: json["d2"],
        d3: json["d3"],
        d4: json["d4"],
        d5: json["d5"],
        d6: json["d6"],
    );

    Map<String, dynamic> toJson() => {
        "d1": d1,
        "d2": d2,
        "d3": d3,
        "d4": d4,
        "d5": d5,
        "d6": d6,
    };
}
