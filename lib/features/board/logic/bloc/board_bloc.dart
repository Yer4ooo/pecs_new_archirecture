import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import '../models/board_model.dart';

part 'board_event.dart';
part 'board_state.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  final Dio dio;

  BoardBloc({required this.dio}) : super(BoardInitial()) {
    on<FetchBoards>((event, emit) async {
      emit(BoardLoading());

      try {
        final tokenBox = Hive.box('token');
        final token = tokenBox.get('tkn');

        final response = await dio.get(
          "https://api.pecs.qys.kz/my_board",
          options: Options(
            headers: {
              "Authorization": "Bearer $token",
            },
          ),
        );

        final BoardResponseModel boardData =
        BoardResponseModel.fromJson(response.data);

        emit(BoardSuccess(boardData: boardData));
      } catch (error) {
        emit(BoardFailure(error: error.toString()));
      }
    });
    on<CreateBoard>((event, emit) async {
      emit(BoardLoading());

      try {
        final tokenBox = Hive.box('token');
        final token = tokenBox.get('tkn');

        final response = await dio.post(
          "https://api.pecs.qys.kz/my_boards",
          data: {
            "name": event.name,
          },
          options: Options(
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
          ),
        );

        final createdName = response.data['name'];
        emit(BoardCreated(boardName: createdName));
      } catch (error) {
        emit(BoardFailure(error: error.toString()));
      }
    });

  }
}
