import 'package:pecs_new_arch/core/resources/data_state.dart';
import 'package:pecs_new_arch/core/usecase/usecase.dart';
import 'package:pecs_new_arch/features/board/data/models/board_update_request_model.dart';
import 'package:pecs_new_arch/features/board/data/models/board_update_response_model.dart';
import 'package:pecs_new_arch/features/board/domain/repository/board_repository.dart';

class UpdateBoardUsecase
    implements UseCase<DataState<BoardUpdateResponseModel>, UpdateBoardParams> {
  final BoardRepository _boardRepository;
  UpdateBoardUsecase(this._boardRepository);

  @override
  Future<DataState<BoardUpdateResponseModel>> call(
      {UpdateBoardParams? params}) async {
    return await _boardRepository.updateBoard(
        childId: params?.childId,
        boardId: params?.boardId,
        board: params?.board);
  }
}

class UpdateBoardParams {
  final int? childId;
  final int? boardId;
  final BoardUpdateRequestModel? board;
  const UpdateBoardParams({
    required this.childId,
    required this.boardId,
    required this.board,
  });
}
