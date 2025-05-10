part of 'board_bloc.dart';

abstract class BoardEvent {}

class FetchBoards extends BoardEvent {}

class CreateBoard extends BoardEvent {
  final String name;

  CreateBoard({required this.name});
}


class PlayTTS extends BoardEvent {
  final String text;

  PlayTTS({required this.text});
}