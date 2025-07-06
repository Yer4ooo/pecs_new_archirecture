import 'package:pecs_new_arch/core/resources/data_state.dart';
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

abstract class BoardRepository {
  Future<DataState<BoardModel?>> getBoard({int? id});
  Future<DataState<BoardDetailsModel?>> getBoardDetail({int? id});
  Future<DataState<BoardCreateResponseModel>> createBoard(
      {BoardCreateRequestModel? board, int? id});
  Future<DataState<TabCreateResponseModel>> createTab(
      {TabCreateRequestModel? tab});
  Future<DataState<dynamic>> playTts({TtsPlayRequestModel? tts});
  Future<DataState<BoardDeleteResponseModel>> deleteBoard(
      {int? childId, int? boardId});
  Future<DataState<BoardUpdateResponseModel>> updateBoard(
      {int? childId, int? boardId, BoardUpdateRequestModel? board});
}
