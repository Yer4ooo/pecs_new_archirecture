import 'package:pecs_new_arch/core/resources/data_state.dart';
import 'package:pecs_new_arch/core/usecase/usecase.dart';
import 'package:pecs_new_arch/features/board/data/models/board_delete_response_model.dart';
import 'package:pecs_new_arch/features/board/domain/repository/board_repository.dart';

class DeleteBoardUsecase
    implements UseCase<DataState<BoardDeleteResponseModel>, DeleteBoardParams> {
  final BoardRepository _boardRepository;
  DeleteBoardUsecase(this._boardRepository);

  @override
  Future<DataState<BoardDeleteResponseModel>> call(
      {DeleteBoardParams? params}) async {
    return await _boardRepository.deleteBoard(
        childId: params?.childId, boardId: params?.boardId);
  }
}

class DeleteBoardParams {
  final int? childId;
  final int? boardId;
  const DeleteBoardParams({
    required this.childId,
    required this.boardId,
  });
}
