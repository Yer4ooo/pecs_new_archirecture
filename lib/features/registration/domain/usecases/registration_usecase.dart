import 'package:pecs_new_arch/core/resources/data_state.dart';
import 'package:pecs_new_arch/core/usecase/usecase.dart';

import '../../../../core/network/custom_exceptions.dart';
import '../../data/models/registration_request_model.dart';
import '../../data/models/registration_success_response_model.dart';
import '../repository/registration_repository.dart';

class RegisterUsecase
    implements UseCase<DataState<RegisterResponseModel>, RegisterRequestModel> {
  final RegisterRepository _registerRepository;

  RegisterUsecase(this._registerRepository);

  @override
  Future<DataState<RegisterResponseModel>> call({
    RegisterRequestModel? params,
  }) async {
    if (params == null) {
      return DataFailed(CustomException(message: "Params cannot be null"));
    }
    return await _registerRepository.register(registerUser: params);
  }

}
