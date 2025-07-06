import 'package:pecs_new_arch/core/usecase/usecase.dart';
import 'package:pecs_new_arch/features/board/data/models/board_create_request_model.dart';
import 'package:pecs_new_arch/features/board/data/models/board_create_response_model.dart';
import 'package:pecs_new_arch/features/board/domain/repository/board_repository.dart';

import '../../../../core/resources/data_state.dart';

class CreateBoardUsecase
    implements UseCase<DataState<BoardCreateResponseModel>, CreateBoardParams> {
  final BoardRepository _boardRepository;

  CreateBoardUsecase(this._boardRepository);

  @override
  Future<DataState<BoardCreateResponseModel>> call(
      {CreateBoardParams? params}) async {
    return await _boardRepository.createBoard(
        board: params?.board, id: params?.id);
  }
}

class CreateBoardParams {
  final BoardCreateRequestModel? board;
  final int? id;

  const CreateBoardParams({
    required this.board,
    required this.id,
  });
}
