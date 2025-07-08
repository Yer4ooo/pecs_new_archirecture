part of 'board_bloc.dart';

@freezed
class BoardEvent with _$BoardEvent {
  const factory BoardEvent.getBoard({int? id}) = GetBoard;
  const factory BoardEvent.getBoardDetails({int? id}) = GetBoardDetails;
  const factory BoardEvent.createBoard(
      {BoardCreateRequestModel? board, int? id}) = CreateBoard;
  const factory BoardEvent.createTab({TabCreateRequestModel? tab}) = CreateTab;
  const factory BoardEvent.playTts({TtsPlayRequestModel? tts}) = PlayTts;
  const factory BoardEvent.deleteBoard({int? childId, int? boardId}) =
      DeleteBoard;
  const factory BoardEvent.updateBoard(
      {int? childId,
      int? boardId,
      BoardUpdateRequestModel? board}) = UpdateBoard;
  const factory BoardEvent.updateTab(TabUpdateRequestModel? tab) = UpdateTab;
  const factory BoardEvent.deleteTab({int? tabId}) =
  DeleteTab;
}
