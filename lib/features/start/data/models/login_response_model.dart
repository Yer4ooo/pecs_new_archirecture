// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) {
  final jsonData = json.decode(str);
  return LoginResponseModel.fromJson(jsonData);
}

String loginResponseModelToJson(LoginResponseModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class LoginResponseModel {
  String refresh;
  String access;
  String userRole;
  int userId;
  int roleId;
  String displayName;
  bool isStaff;

  LoginResponseModel({
    required this.refresh,
    required this.access,
    required this.userRole,
    required this.userId,
    required this.roleId,
    required this.displayName,
    required this.isStaff,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        refresh: json["refresh"],
        access: json["access"],
        userRole: json["user_role"],
        userId: json["user_id"],
        roleId: json["role_id"],
        displayName: json["display_name"],
        isStaff: json["is_staff"],
      );

  Map<String, dynamic> toJson() => {
        "refresh": refresh,
        "access": access,
        "user_role": userRole,
        "user_id": userId,
        "role_id": roleId,
        "display_name": displayName,
        "is_staff": isStaff,
      };
}
