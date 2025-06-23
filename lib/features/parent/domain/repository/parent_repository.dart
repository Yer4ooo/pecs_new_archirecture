import 'package:pecs_new_arch/core/resources/data_state.dart';
import 'package:pecs_new_arch/features/parent/data/models/children_list_response_model_response.dart';

abstract class ParentRepository {
  Future<DataState<ChildrenListResponseModel?>> getChildrenList();
}
