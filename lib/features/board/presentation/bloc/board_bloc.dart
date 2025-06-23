import 'package:pecs_new_arch/core/mixin/bloc_operations_mixin.dart';
import 'package:pecs_new_arch/features/board/data/models/board_create_request_model.dart';
import 'package:pecs_new_arch/features/board/data/models/board_create_response_model.dart';
import 'package:pecs_new_arch/features/board/data/models/board_details_model.dart';
import 'package:pecs_new_arch/features/board/data/models/board_model.dart';
import 'package:pecs_new_arch/features/board/data/models/tab_create_request_model.dart';
import 'package:pecs_new_arch/features/board/data/models/tab_create_response_model.dart';
import 'package:pecs_new_arch/features/board/data/models/tts_play_request_model.dart';
import 'package:pecs_new_arch/features/board/domain/usecases/create_board_usecase.dart';
import 'package:pecs_new_arch/features/board/domain/usecases/create_tab_usecase.dart';
import 'package:pecs_new_arch/features/board/domain/usecases/get_board_details_usecase.dart';
import 'package:pecs_new_arch/features/board/domain/usecases/get_board_usecase.dart';
import 'package:pecs_new_arch/features/board/domain/usecases/play_tts_usecase.dart';
import 'package:pecs_new_arch/injection_container.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc/bloc.dart';

part 'board_event.dart';
part 'board_state.dart';
part 'board_bloc.freezed.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState>
    with BlocEventHandlerMixin<BoardEvent, BoardState> {
  BoardBloc() : super(_Initial()) {
    final GetBoardUsecase _getBoardUsecase = sl();
    final GetBoardDetailsUsecase _getBoardDetailsUsecase = sl();
    final CreateBoardUsecase _createBoardUsecase = sl();
    final CreateTabUsecase _createTabUsecase = sl();
    final PlayTtsUsecase _playTtsUsecase = sl();

    on<BoardEvent>((events, emit) async {
      await events.map(
        getBoard: (GetBoard id) async => await handleEvent<BoardModel?>(
          operation: () => _getBoardUsecase.call(params: id.id),
          emit: emit,
          onLoading: () => const BoardState.boardLoading(),
          onSuccess: (data) async => BoardState.boardLoaded(data),
          onFailure: (error) async => BoardState.boardError(error.message),
        ),
        getBoardDetails: (GetBoardDetails id) async =>
            await handleEvent<BoardDetailsModel?>(
          operation: () => _getBoardDetailsUsecase.call(params: id.id),
          emit: emit,
          onLoading: () => const BoardState.boardDetailsLoading(),
          onSuccess: (data) async => BoardState.boardDetailsLoaded(data),
          onFailure: (error) async =>
              BoardState.boardDetailsError(error.message),
        ),
        createBoard: (CreateBoard board) async =>
            await handleEvent<BoardCreateResponseModel>(
          operation: () => _createBoardUsecase.call(params: board.board),
          emit: emit,
          onLoading: () => const BoardState.createBoardLoading(),
          onSuccess: (data) async => BoardState.createBoardSuccess(data),
          onFailure: (error) async =>
              BoardState.createBoardError(error.message),
        ),
        createTab: (CreateTab tab) async =>
            await handleEvent<TabCreateResponseModel>(
          operation: () => _createTabUsecase.call(params: tab.tab),
          emit: emit,
          onLoading: () => const BoardState.createTabLoading(),
          onSuccess: (data) async => BoardState.createTabSuccess(data),
          onFailure: (error) async => BoardState.createTabError(error.message),
        ),
        playTts: (PlayTts tts) async {
          // Extract current board details from state
          final currentBoardDetails = state.maybeWhen(
            boardDetailsLoaded: (boardDetails) => boardDetails,
            playTtsLoading: (boardDetails) => boardDetails,
            playTtsSuccess: (boardDetails, _) => boardDetails,
            playTtsError: (boardDetails, _) => boardDetails,
            orElse: () => null,
          );

          return await handleEvent<dynamic>(
            operation: () => _playTtsUsecase.call(params: tts.tts),
            emit: emit,
            onLoading: () => BoardState.playTtsLoading(currentBoardDetails),
            onSuccess: (data) async =>
                BoardState.playTtsSuccess(currentBoardDetails, data),
            onFailure: (error) async =>
                BoardState.playTtsError(currentBoardDetails, error.message),
          );
        },
      );
    });
  }
}
