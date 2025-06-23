part of 'board_bloc.dart';

@freezed
class BoardEvent with _$BoardEvent {
  const factory BoardEvent.getBoard({int? id}) = GetBoard;
  const factory BoardEvent.getBoardDetails({int? id}) = GetBoardDetails;
  const factory BoardEvent.createBoard(
      {BoardCreateRequestModel? board, int? id}) = CreateBoard;
  const factory BoardEvent.createTab({TabCreateRequestModel? tab}) = CreateTab;
  const factory BoardEvent.playTts({TtsPlayRequestModel? tts}) = PlayTts;
}
