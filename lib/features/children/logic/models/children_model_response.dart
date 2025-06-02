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
  dynamic profilePic;
  String gender;
  String dateOfBirth;
  List<dynamic> specialistsSolo;
  List<dynamic> organisations;
  String username;

  Child({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profilePic,
    required this.gender,
    required this.dateOfBirth,
    required this.specialistsSolo,
    required this.organisations,
    required this.username,
  });

  factory Child.fromJson(Map<String, dynamic> json) => new Child(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    profilePic: json["profile_pic"],
    gender: json["gender"],
    dateOfBirth: json["date_of_birth"],
    specialistsSolo: new List<dynamic>.from(json["specialists_solo"].map((x) => x)),
    organisations: new List<dynamic>.from(json["organisations"].map((x) => x)),
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "profile_pic": profilePic,
    "gender": gender,
    "date_of_birth": dateOfBirth,
    "specialists_solo": new List<dynamic>.from(specialistsSolo.map((x) => x)),
    "organisations": new List<dynamic>.from(organisations.map((x) => x)),
    "username": username,
  };
}
