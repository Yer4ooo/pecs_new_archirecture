import 'package:pecs_new_arch/core/usecase/usecase.dart';
import 'package:pecs_new_arch/features/board/data/models/board_model.dart';
import 'package:pecs_new_arch/features/board/domain/repository/board_repository.dart';
import '../../../../core/resources/data_state.dart';

class GetBoardUsecase implements UseCase<DataState<BoardModel?>, int?> {
  final BoardRepository _boardRepository;
  GetBoardUsecase(this._boardRepository);

  @override
  Future<DataState<BoardModel?>> call({params}) async {
    return await _boardRepository.getBoard(id: params);
  }
}
