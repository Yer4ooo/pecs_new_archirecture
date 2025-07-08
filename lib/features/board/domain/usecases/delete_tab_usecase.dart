import 'package:pecs_new_arch/core/resources/data_state.dart';
import 'package:pecs_new_arch/core/usecase/usecase.dart';
import 'package:pecs_new_arch/features/board/data/models/board_delete_response_model.dart';
import 'package:pecs_new_arch/features/board/domain/repository/board_repository.dart';

import '../../data/models/tab_delete_response_model.dart';

class DeleteTabUsecase
    implements UseCase<DataState<TabDeleteResponseModel>, int> {
  final BoardRepository _boardRepository;
  DeleteTabUsecase(this._boardRepository);

  @override
  Future<DataState<TabDeleteResponseModel>> call(
      {int? params}) async {
    return await _boardRepository.deleteTab(tabId: params);
  }
}

