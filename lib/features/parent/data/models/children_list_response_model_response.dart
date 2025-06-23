import 'dart:convert';

ChildrenListResponseModel childrenListResponseModelFromJson(String str) {
  final jsonData = json.decode(str);
  return ChildrenListResponseModel.fromJson(jsonData);
}

String childrenListResponseModelToJson(ChildrenListResponseModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class ChildrenListResponseModel {
  List<Child> children;
  int parentId;

  ChildrenListResponseModel({
    required this.children,
    required this.parentId,
  });

  factory ChildrenListResponseModel.fromJson(Map<String, dynamic> json) =>
      ChildrenListResponseModel(
        children:
            List<Child>.from(json["children"].map((x) => Child.fromJson(x))),
        parentId: json["parent_id"],
      );

  Map<String, dynamic> toJson() => {
        "children": List<dynamic>.from(children.map((x) => x.toJson())),
        "parent_id": parentId,
      };
}

class Child {
  int id;
  String firstName;
  String lastName;
  String username;
  int age;
  dynamic profilePic;
  String gender;
  String dateOfBirth;
  String registrationDate;
  List<dynamic> specialistSolos;
  List<dynamic> organisations;

  Child({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.age,
    required this.profilePic,
    required this.gender,
    required this.dateOfBirth,
    required this.registrationDate,
    required this.specialistSolos,
    required this.organisations,
  });

  factory Child.fromJson(Map<String, dynamic> json) => Child(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        username: json["username"],
        age: json["age"],
        profilePic: json["profile_pic"],
        gender: json["gender"],
        dateOfBirth: json["date_of_birth"],
        registrationDate: json["registration_date"],
        specialistSolos:
            List<dynamic>.from(json["specialist_solos"].map((x) => x)),
        organisations: List<dynamic>.from(json["organisations"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "username": username,
        "age": age,
        "profile_pic": profilePic,
        "gender": gender,
        "date_of_birth": dateOfBirth,
        "registration_date": registrationDate,
        "specialist_solos": List<dynamic>.from(specialistSolos.map((x) => x)),
        "organisations": List<dynamic>.from(organisations.map((x) => x)),
      };
}
