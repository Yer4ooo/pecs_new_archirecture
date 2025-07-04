import 'package:pecs_new_arch/core/network/custom_exceptions.dart';
import 'package:pecs_new_arch/core/resources/data_state.dart';
import 'package:pecs_new_arch/features/board/data/datasource/board_api_service.dart';
import 'package:pecs_new_arch/features/board/data/models/board_create_request_model.dart';
import 'package:pecs_new_arch/features/board/data/models/board_create_response_model.dart';
import 'package:pecs_new_arch/features/board/data/models/board_details_model.dart';
import 'package:pecs_new_arch/features/board/data/models/board_model.dart';
import 'package:pecs_new_arch/features/board/data/models/tab_create_request_model.dart';
import 'package:pecs_new_arch/features/board/data/models/tab_create_response_model.dart';
import 'package:pecs_new_arch/features/board/data/models/tts_play_request_model.dart';
import 'package:pecs_new_arch/features/board/domain/repository/board_repository.dart';

class BoardRepositoryImpl implements BoardRepository {
  final BoardApiService _boardApiService;

  BoardRepositoryImpl(this._boardApiService);

  @override
  Future<DataState<BoardModel>> getBoard({int? id}) async {
    try {
      var data = await _boardApiService.getBoard(id: id);
      if (data != null) {
        return DataSuccess(data);
      } else {
        return DataFailed(CustomException(message: ''));
      }
    } on CustomException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<BoardCreateResponseModel>> createBoard(
      {BoardCreateRequestModel? board, int? id}) async {
    try {
      var data = await _boardApiService.createBoard(id: id);
      if (data != null) {
        return DataSuccess(data);
      } else {
        return DataFailed(CustomException(message: ''));
      }
    } on CustomException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<TabCreateResponseModel>> createTab(
      {TabCreateRequestModel? tab}) async {
    try {
      var data = await _boardApiService.createTab(tab: tab);
      if (data != null) {
        return DataSuccess(data);
      } else {
        return DataFailed(CustomException(message: ''));
      }
    } on CustomException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<BoardDetailsModel?>> getBoardDetail({int? id}) async {
    try {
      var data = await _boardApiService.getBoardDetails(id: id);
      if (data != null) {
        return DataSuccess(data);
      } else {
        return DataFailed(CustomException(message: ''));
      }
    } on CustomException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<dynamic>> playTts({TtsPlayRequestModel? tts}) async {
    try {
      var data = await _boardApiService.playTts(tts: tts);
      if (data != null) {
        return DataSuccess(data);
      } else {
        return DataFailed(CustomException(message: 'GG'));
      }
    } on CustomException catch (e) {
      return DataFailed(e);
    }
  }
}
