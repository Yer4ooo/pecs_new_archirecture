import 'dart:typed_data';
import 'package:pecs_new_arch/core/network/network_client.dart';
import 'package:pecs_new_arch/features/board/data/models/board_create_request_model.dart';
import 'package:pecs_new_arch/features/board/data/models/board_create_response_model.dart';
import 'package:pecs_new_arch/features/board/data/models/board_delete_response_model.dart';
import 'package:pecs_new_arch/features/board/data/models/board_details_model.dart';
import 'package:pecs_new_arch/features/board/data/models/board_model.dart';
import 'package:pecs_new_arch/features/board/data/models/board_update_request_model.dart';
import 'package:pecs_new_arch/features/board/data/models/board_update_response_model.dart';
import 'package:pecs_new_arch/features/board/data/models/tab_create_request_model.dart';
import 'package:pecs_new_arch/features/board/data/models/tab_create_response_model.dart';
import 'package:pecs_new_arch/features/board/data/models/tts_play_request_model.dart';
import 'package:pecs_new_arch/injection_container.dart';

class BoardApiService {
  BoardApiService();
  final NetworkClient _networkClient = sl.get<NetworkClient>();

  Future<BoardModel?> getBoard({required int? id}) =>
      _networkClient.getData<BoardModel>(
          endpoint: 'boards/$id',
          parser: (response) => BoardModel.fromJson(response));

  Future<BoardDetailsModel?> getBoardDetails({required int? id}) =>
      _networkClient.getData<BoardDetailsModel>(
          endpoint: 'boards/$id/details/',
          parser: (response) => BoardDetailsModel.fromJson(response));

  Future<BoardCreateResponseModel?> createBoard(
          {BoardCreateRequestModel? board, required int? id}) =>
      _networkClient.postData<BoardCreateResponseModel>(
          endpoint: 'boards/$id/',
          body: board,
          parser: (response) => BoardCreateResponseModel.fromJson(response));

  Future<TabCreateResponseModel?> createTab({TabCreateRequestModel? tab}) =>
      _networkClient.postData<TabCreateResponseModel>(
          endpoint: 'boards/tabs/',
          body: tab,
          parser: (response) => TabCreateResponseModel.fromJson(response));

  Future<Uint8List?> playTts({TtsPlayRequestModel? tts}) async {
    return await _networkClient.postTtsDataIsolated(
      endpoint: 'tts/convert',
      body: {
        "image_ids": tts?.imageIds ?? [],
        "voice_language": tts?.voiceLanguage,
      },
    );
  }

  Future<BoardDeleteResponseModel?> deleteBoard(
          {required int? childId, required int? boardId}) =>
      _networkClient.deleteData<BoardDeleteResponseModel>(
          endpoint: 'boards/$childId/?board_id=$boardId',
          parser: (response) => BoardDeleteResponseModel.fromJson(response));

  Future<BoardUpdateResponseModel?> updateBoard(
      {required int? childId,
      required int? boardId,
      required BoardUpdateRequestModel? board}) {
    return _networkClient.updateData<BoardUpdateResponseModel>(
        endpoint: 'boards/$childId/?board_id=$boardId',
        body: board?.toJson(),
        parser: (response) => BoardUpdateResponseModel.fromJson(response));
  }
}
