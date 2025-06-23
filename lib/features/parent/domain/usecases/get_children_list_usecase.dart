import 'package:pecs_new_arch/core/resources/data_state.dart';
import 'package:pecs_new_arch/core/usecase/usecase.dart';
import 'package:pecs_new_arch/features/parent/data/models/children_list_response_model_response.dart';
import 'package:pecs_new_arch/features/parent/domain/repository/parent_repository.dart';

class GetChildrenListUsecase
    implements UseCase<DataState<ChildrenListResponseModel?>, void> {
  final ParentRepository _parentRepository;
  GetChildrenListUsecase(this._parentRepository);

  @override
  Future<DataState<ChildrenListResponseModel?>> call({void params}) async {
    return await _parentRepository.getChildrenList();
  }
}
