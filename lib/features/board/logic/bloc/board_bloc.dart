import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pecs_new_arch/features/board/logic/models/tab_create_model.dart';
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

    on<CreateTabForChild>((event, emit) async {
      final token = await GetIt.I<KeyValueStorageService>().getAccessToken();

      emit(BoardLoading());

      try {
        final tabCreateModel = TabCreateModel(
          name: event.name,
          color: event.color,
          boardId: event.boardId,
          strapsNum: event.strapsNum,
        );

        final response = await dio.post(
          "https://api.pecs.qys.kz/boards/tabs/",
          data: tabCreateModel.toJson(),
          options: Options(
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
          ),
        );
        emit(TabCreated(tabName: event.name));
      } catch (error) {
        emit(BoardFailure(error: error.toString()));
      }
    });

    on<PlayTTS>((event, emit) async {
      final token = await GetIt.I<KeyValueStorageService>().getAccessToken();
      try {
        Response response = await dio.post(
          "https://api.pecs.qys.kz/tts/convert",
          data: {
            "image_ids": event.image_ids,
            "voice_language": "en",
          },
          options: Options(
            responseType: ResponseType.bytes,
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
          ),
        );
        if (state is BoardDetailsSuccess) {
          emit(TTSPlaySuccess(
            text: response.data,
            boardDetails: (state as BoardDetailsSuccess).boardDetails,
          ));
        } else {
          emit(TTSPlayFailure(error: "Board details are not available"));
        }
      } catch (error) {
        emit(TTSPlayFailure(error: error.toString()));
      }
    });
  }
}
