import 'package:pecs_new_arch/core/network/network_client.dart';
import 'package:pecs_new_arch/features/parent/data/models/children_list_response_model_response.dart';
import 'package:pecs_new_arch/injection_container.dart';

class ParentApiService {
  ParentApiService();
  final NetworkClient _networkClient = sl.get<NetworkClient>();

  Future<ChildrenListResponseModel?> getChildrenList() =>
      _networkClient.getData(
          endpoint: 'parent/children',
          parser: (response) => ChildrenListResponseModel.fromJson(response));
}
