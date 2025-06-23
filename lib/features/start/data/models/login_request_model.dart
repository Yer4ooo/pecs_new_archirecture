import 'dart:convert';

LoginRequestModel loginRequestModelFromJson(String str) => LoginRequestModel.fromJson(json.decode(str));

String loginRequestModelToJson(LoginRequestModel data) => json.encode(data.toJson());

class LoginRequestModel {
  String identifier;
  String password;

  LoginRequestModel({
    required this.identifier,
    required this.password,
  });

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) => LoginRequestModel(
        identifier: json["identifier"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "username": identifier,
        "password": password,
      };
}
