import 'package:pecs_new_arch/core/usecase/usecase.dart';
import 'package:pecs_new_arch/features/board/data/models/tab_create_request_model.dart';
import 'package:pecs_new_arch/features/board/data/models/tab_create_response_model.dart';
import 'package:pecs_new_arch/features/board/domain/repository/board_repository.dart';

import '../../../../core/resources/data_state.dart';

class CreateTabUsecase
    implements
        UseCase<DataState<TabCreateResponseModel>, TabCreateRequestModel?> {
  final BoardRepository _boardRepository;
  CreateTabUsecase(this._boardRepository);

  @override
  Future<DataState<TabCreateResponseModel>> call({params}) async {
    return await _boardRepository.createTab(tab: params);
  }
}
