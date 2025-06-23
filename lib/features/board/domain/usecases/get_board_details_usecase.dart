import 'package:pecs_new_arch/core/usecase/usecase.dart';
import 'package:pecs_new_arch/features/board/data/models/board_details_model.dart';
import 'package:pecs_new_arch/features/board/domain/repository/board_repository.dart';

import '../../../../core/resources/data_state.dart';

class GetBoardDetailsUsecase
    implements UseCase<DataState<BoardDetailsModel?>, int?> {
  final BoardRepository _boardRepository;
  GetBoardDetailsUsecase(this._boardRepository);

  @override
  Future<DataState<BoardDetailsModel?>> call({params}) async {
    return await _boardRepository.getBoardDetail(id: params);
  }
}
