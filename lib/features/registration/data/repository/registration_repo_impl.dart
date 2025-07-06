import 'package:pecs_new_arch/core/network/custom_exceptions.dart';
import 'package:pecs_new_arch/core/resources/data_state.dart';

import '../../domain/repository/registration_repository.dart';
import '../datasourse/registration_api_service.dart';
import '../models/registration_request_model.dart';
import '../models/registration_success_response_model.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterApiService _registerApiService;

  RegisterRepositoryImpl(this._registerApiService);

  @override
  Future<DataState<RegisterResponseModel>> register({
    required RegisterRequestModel registerUser,
  }) async {
    try {
      final response = await _registerApiService.register(registerUser);

      if (response != null) {
        return DataSuccess(response);
      } else {
        return DataFailed(CustomException(message: 'Unknown error occurred'));
      }
    } on CustomException catch (e) {
      return DataFailed(e);
    }
  }
}
