import 'package:pecs_new_arch/core/resources/data_state.dart';
import 'package:pecs_new_arch/core/usecase/usecase.dart';
import 'package:pecs_new_arch/features/board/data/models/tab_create_request_model.dart';
import 'package:pecs_new_arch/features/board/domain/repository/board_repository.dart';
import '../../data/models/tab_update_request_model.dart';
import '../../data/models/tab_update_response_model.dart';

class UpdateTabUsecase
    implements
        UseCase<DataState<TabUpdateResponseModel>, TabUpdateRequestModel?> {
  final BoardRepository _boardRepository;

  UpdateTabUsecase(this._boardRepository);

  @override
  Future<DataState<TabUpdateResponseModel>> call({params}) async {
    return await _boardRepository.updateTab(tab: params);
  }
}
