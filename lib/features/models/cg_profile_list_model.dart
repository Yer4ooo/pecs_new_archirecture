import 'dart:convert';

CgProfileListModel cgProfileListModelFromJson(String str) => CgProfileListModel.fromJson(json.decode(str));

String cgProfileListModelToJson(CgProfileListModel data) => json.encode(data.toJson());

class CgProfileListModel {
    String username;
    String email;
    String firstName;
    String lastName;
    bool isActive;
    DateTime dateJoined;
    bool isCg;
    List<CareReceiver> careReceivers;

    CgProfileListModel({
        required this.username,
        required this.email,
        required this.firstName,
        required this.lastName,
        required this.isActive,
        required this.dateJoined,
        required this.isCg,
        required this.careReceivers,
    });

    factory CgProfileListModel.fromJson(Map<String, dynamic> json) => CgProfileListModel(
        username: json["username"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        isActive: json["is_active"],
        dateJoined: DateTime.parse(json["date_joined"]),
        isCg: json["is_cg"],
        careReceivers: List<CareReceiver>.from(json["care_receivers"].map((x) => CareReceiver.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "is_active": isActive,
        "date_joined": dateJoined.toIso8601String(),
        "is_cg": isCg,
        "care_receivers": List<dynamic>.from(careReceivers.map((x) => x.toJson())),
    };
}

class CareReceiver {
    String user;
    int userId;
    String profilePicture;

    CareReceiver({
        required this.user,
        required this.userId,
        required this.profilePicture,
    });

    factory CareReceiver.fromJson(Map<String, dynamic> json) => CareReceiver(
        user: json["user"],
        userId: json["user_id"],
        profilePicture: json["profile_picture"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "user_id": userId,
        "profile_picture": profilePicture,
    };
}
