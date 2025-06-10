import 'dart:convert';

ChildrenModel childrenModelFromJson(String str) {
  final jsonData = json.decode(str);
  return ChildrenModel.fromJson(jsonData);
}

String childrenModelToJson(ChildrenModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class ChildrenModel {
  List<Child> children;
  int parentId;

  ChildrenModel({
    required this.children,
    required this.parentId,
  });

  factory ChildrenModel.fromJson(Map<String, dynamic> json) => new ChildrenModel(
    children: new List<Child>.from(json["children"].map((x) => Child.fromJson(x))),
    parentId: json["parent_id"],
  );

  Map<String, dynamic> toJson() => {
    "children": new List<dynamic>.from(children.map((x) => x.toJson())),
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
    required this.specialistSolos,
    required this.organisations,
  });

  factory Child.fromJson(Map<String, dynamic> json) => new Child(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    username: json["username"],
    age: json["age"],
    profilePic: json["profile_pic"],
    gender: json["gender"],
    dateOfBirth: json["date_of_birth"],
    specialistSolos: new List<dynamic>.from(json["specialist_solos"].map((x) => x)),
    organisations: new List<dynamic>.from(json["organisations"].map((x) => x)),
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
    "specialist_solos": new List<dynamic>.from(specialistSolos.map((x) => x)),
    "organisations": new List<dynamic>.from(organisations.map((x) => x)),
  };
}