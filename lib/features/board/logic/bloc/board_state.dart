part of 'board_bloc.dart';

abstract class BoardState {}

class BoardInitial extends BoardState {}

class BoardLoading extends BoardState {}

class BoardSuccess extends BoardState {
  final BoardModel boardData;

  BoardSuccess({required this.boardData});
}

class BoardDetailsSuccess extends BoardState{
  final BoardDetailsModel boardDetails;

  BoardDetailsSuccess({required this.boardDetails});
}
class BoardDetailsFailure extends BoardState {
  final String error;

  BoardDetailsFailure({required this.error});
}
class BoardCreated extends BoardState {
  final String boardName;

  BoardCreated({required this.boardName});
}

class BoardFailure extends BoardState {
  final String error;

  BoardFailure({required this.error});
}

class TTSPlaySuccess extends BoardState {
  final List<int> text;

  TTSPlaySuccess({required this.text});
}

class TTSPlayFailure extends BoardState {
  final String error;

  TTSPlayFailure({required this.error});
}
