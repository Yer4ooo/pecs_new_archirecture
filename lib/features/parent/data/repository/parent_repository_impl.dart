import 'package:pecs_new_arch/core/network/custom_exceptions.dart';
import 'package:pecs_new_arch/core/resources/data_state.dart';
import 'package:pecs_new_arch/features/parent/data/datasource/parent_api_service.dart';
import 'package:pecs_new_arch/features/parent/data/models/children_list_response_model_response.dart';
import 'package:pecs_new_arch/features/parent/domain/repository/parent_repository.dart';

class ParentRepositoryImpl implements ParentRepository {
  final ParentApiService _parentApiService;

  ParentRepositoryImpl(this._parentApiService);

  @override
  Future<DataState<ChildrenListResponseModel>> getChildrenList() async {
    try {
      var data = await _parentApiService.getChildrenList();
      if (data != null) {
        return DataSuccess(data);
      } else {
        return DataFailed(CustomException(message: ''));
      }
    } on CustomException catch (e) {
      return DataFailed(e);
    }
  }
}
