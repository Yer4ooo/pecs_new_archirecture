part of 'board_bloc.dart';

abstract class BoardState {}

class BoardInitial extends BoardState {}

class BoardLoading extends BoardState {}

class BoardSuccess extends BoardState {
  final BoardModel boardData;

  BoardSuccess({required this.boardData});
}

class BoardCreated extends BoardState {
  final String boardName;

  BoardCreated({required this.boardName});
}

class BoardFailure extends BoardState {
  final String error;

  BoardFailure({required this.error});
}
