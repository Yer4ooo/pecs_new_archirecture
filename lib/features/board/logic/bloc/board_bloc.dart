import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import '../../../../core/utils/key_value_storage_service.dart';
import '../models/board_create_model.dart';
import '../models/board_details_model.dart';
import '../models/board_model.dart';

part 'board_event.dart';
part 'board_state.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  BoardBloc() : super(BoardInitial()) {
    final dio = Dio();

    on<FetchBoardsById>((event, emit) async {
      final token = await GetIt.I<KeyValueStorageService>().getAccessToken();

      emit(BoardLoading());

      try {
        final response = await dio.get(
          "https://api.pecs.qys.kz/boards/${event.childId}/",
          options: Options(
            headers: {
              "Authorization": "Bearer $token",
            },
          ),
        );
        final BoardModel boardData = BoardModel.fromJson(response.data);
        emit(BoardSuccess(boardData: boardData));
      } catch (error) {
        emit(BoardFailure(error: error.toString()));
      }
    });
    on<FetchBoardDetails>((event, emit) async {
      final token = await GetIt.I<KeyValueStorageService>().getAccessToken();

      emit(BoardLoading());

      try {
        final response = await dio.get(
          "https://api.pecs.qys.kz/boards/${event.boardId}/details/",
          options: Options(
            headers: {
              "Authorization": "Bearer $token",
            },
          ),
        );
        final BoardDetailsModel boardDetails = BoardDetailsModel.fromJson(response.data);
        emit(BoardDetailsSuccess(boardDetails: boardDetails));
      } catch (error) {
        emit(BoardDetailsFailure(error: error.toString()));
      }
    });

    on<CreateBoardForChild>((event, emit) async {
      final token = await GetIt.I<KeyValueStorageService>().getAccessToken();

      emit(BoardLoading());

      try {
        final boardCreateModel = BoardCreateModel(
          name: event.name,
          private: event.private,
          color: event.color,
        );

        final response = await dio.post(
          "https://api.pecs.qys.kz/boards/${event.childId}/",
          data: boardCreateModel.toJson(),
          options: Options(
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
          ),
        );
        emit(BoardCreated(boardName: event.name));
      } catch (error) {
        emit(BoardFailure(error: error.toString()));
      }
    });


    on<PlayTTS>((event, emit) async {
      final token = await GetIt.I<KeyValueStorageService>().getAccessToken();
      print("!!!!!!!!!!!!!!!!!!!!!");
      print(event.text);
      print("!!!!!!!!!!!!!!!!!!!!!");
      try {
        Response response = await dio.post(
          "https://api.pecs.qys.kz/tts/convert",
          data: {"text": event.text, "voice_language": "ru"},
          options: Options(
            responseType: ResponseType.bytes,
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
          ),
        );
        print(response.data);
        emit(TTSPlaySuccess(text: response.data));
      } catch (error) {
        emit(TTSPlayFailure(error: error.toString()));
      }
    });
  }
}
