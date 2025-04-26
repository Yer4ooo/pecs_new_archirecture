// models/board_model.dart
class BoardModel {
  // Define fields here if needed
  BoardModel();

  factory BoardModel.fromJson(Map<String, dynamic> json) {
    return BoardModel(); // Update as needed
  }
}

class BoardResponseModel {
  final List<BoardModel> boards;
  final bool isCr;
  final bool isCg;

  BoardResponseModel({
    required this.boards,
    required this.isCr,
    required this.isCg,
  });

  factory BoardResponseModel.fromJson(Map<String, dynamic> json) {
    return BoardResponseModel(
      boards: (json['boards'] as List)
          .map((e) => BoardModel.fromJson(e))
          .toList(),
      isCr: json['is_cr'],
      isCg: json['is_cg'],
    );
  }
}
