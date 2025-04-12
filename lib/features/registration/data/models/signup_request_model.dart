import 'dart:convert';

SignupRequestModel signupRequestModelFromJson(String str) => SignupRequestModel.fromJson(json.decode(str));

String signupRequestModelToJson(SignupRequestModel data) => json.encode(data.toJson());

class SignupRequestModel {
    String username;
    String password;
    String email;
    String firstName;
    String lastName;
    String role;

    SignupRequestModel({
        required this.username,
        required this.password,
        required this.email,
        required this.firstName,
        required this.lastName,
        required this.role,
    });

    factory SignupRequestModel.fromJson(Map<String, dynamic> json) => SignupRequestModel(
        username: json["username"],
        password: json["password"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        role: json["role"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "role": role,
    };
}
