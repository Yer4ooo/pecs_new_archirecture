part of 'board_bloc.dart';

abstract class BoardEvent {}

class CreateBoard extends BoardEvent {
  final String name;

  CreateBoard({required this.name});
}
class FetchBoardDetails extends BoardEvent{
  final String boardId;

  FetchBoardDetails({required this.boardId});
}
class FetchBoardsById extends BoardEvent {
  final String childId;

  FetchBoardsById({required this.childId});
}
class CreateBoardForChild extends BoardEvent {
  final String childId;
  final String name;
  final bool private;
  final String color;

  CreateBoardForChild({
    required this.childId,
    required this.name,
    required this.private,
    required this.color,
  });
}
class CreateTabForChild extends BoardEvent{
  final int boardId;
  final String name;
  final int strapsNum;
  final String color;

  CreateTabForChild({
    required this.boardId,
    required this.name,
    required this.strapsNum,
    required this.color,
  });
}


class PlayTTS extends BoardEvent {
  final List<int> image_ids;

  PlayTTS({required this.image_ids});
}