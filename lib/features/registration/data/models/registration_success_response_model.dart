class RegisterResponseModel {
  final String message;
  final int? parentId;
  final String? username;

  RegisterResponseModel({
    required this.message,
    this.parentId,
    this.username,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      message: json['message'] ?? '',
      parentId: json['parent_id'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'parent_id': parentId,
      'username': username,
    };
  }
}
