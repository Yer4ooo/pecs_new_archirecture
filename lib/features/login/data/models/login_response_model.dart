import 'dart:convert';

LoginResponseModel? loginResponseModelFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel? data) =>
    json.encode(data?.toJson());

class LoginResponseModel {
  String? access;
  String? refresh;
  String? userType;
  int? userId;
  String? username;

  LoginResponseModel({
    this.access,
    this.refresh,
    this.userType,
    this.userId,
    this.username,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return LoginResponseModel();
    return LoginResponseModel(
      access: json["access"],
      refresh: json["refresh"],
      userType: json["user_type"],
      userId: json["user_id"],
      username: json["username"],
    );
  }

  Map<String, dynamic> toJson() => {
        "access": access,
        "refresh": refresh,
        "user_type": userType,
        "user_id": userId,
        "username": username,
      };
}
