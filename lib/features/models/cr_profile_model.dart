import 'dart:convert';

CrProfileModel crProfileModelFromJson(String str) => CrProfileModel.fromJson(json.decode(str));

String crProfileModelToJson(CrProfileModel data) => json.encode(data.toJson());

class CrProfileModel {
    String username;
    String email;
    String firstName;
    String lastName;
    bool isActive;
    DateTime dateJoined;
    bool isCr;
    List<Caregiver> caregivers;

    CrProfileModel({
        required this.username,
        required this.email,
        required this.firstName,
        required this.lastName,
        required this.isActive,
        required this.dateJoined,
        required this.isCr,
        required this.caregivers,
    });

    factory CrProfileModel.fromJson(Map<String, dynamic> json) => CrProfileModel(
        username: json["username"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        isActive: json["is_active"],
        dateJoined: DateTime.parse(json["date_joined"]),
        isCr: json["is_cr"],
        caregivers: List<Caregiver>.from(json["caregivers"].map((x) => Caregiver.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "is_active": isActive,
        "date_joined": dateJoined.toIso8601String(),
        "is_cr": isCr,
        "caregivers": List<dynamic>.from(caregivers.map((x) => x.toJson())),
    };
}

class Caregiver {
    String user;
    int userId;
    String profilePicture;

    Caregiver({
        required this.user,
        required this.userId,
        required this.profilePicture,
    });

    factory Caregiver.fromJson(Map<String, dynamic> json) => Caregiver(
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
