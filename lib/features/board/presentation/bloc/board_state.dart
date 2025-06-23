part of 'board_bloc.dart';

@freezed
class BoardState with _$BoardState {
  const factory BoardState.initial() = _Initial;

  const factory BoardState.boardLoading() = BoardLoading;
  const factory BoardState.boardLoaded(BoardModel? boards) = BoardLoaded;
  const factory BoardState.boardError(String message) = BoardError;

  const factory BoardState.boardDetailsLoading() = BoardDetailsLoading;
  const factory BoardState.boardDetailsLoaded(BoardDetailsModel? boardDetails) =
      BoardDetailsLoaded;
  const factory BoardState.boardDetailsError(String message) =
      BoardDetailsError;

  const factory BoardState.createBoardLoading() = CreateBoardLoading;
  const factory BoardState.createBoardSuccess(BoardCreateResponseModel board) =
      CreateBoardLoaded;
  const factory BoardState.createBoardError(String message) = CreateBoardError;

  const factory BoardState.createTabLoading() = CreateTabLoading;
  const factory BoardState.createTabSuccess(TabCreateResponseModel tab) =
      CreateTabLoaded;
  const factory BoardState.createTabError(String message) = CreateTabError;

  const factory BoardState.playTtsLoading(BoardDetailsModel? boardDetails) =
      PlayTtsLoading;
  const factory BoardState.playTtsSuccess(
      BoardDetailsModel? boardDetails, dynamic tts) = PlayTtsSuccess;
  const factory BoardState.playTtsError(
      BoardDetailsModel? boardDetails, String message) = PlayTtsError;
}
