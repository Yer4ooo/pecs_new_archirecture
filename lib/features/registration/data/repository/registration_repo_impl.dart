import 'package:pecs_new_arch/core/network/custom_exceptions.dart';
import 'package:pecs_new_arch/core/resources/data_state.dart';
import 'package:pecs_new_arch/features/registration/data/datasourse/registration_api_service.dart';
import 'package:pecs_new_arch/features/registration/data/models/registration_model.dart';
import 'package:pecs_new_arch/features/registration/domain/repository/registration_repository.dart';

class RegistrationRepositoryImpl implements RegistrationRepository {
  final RegistrationApiService _registrationApiService;

  RegistrationRepositoryImpl(this._registrationApiService);

  @override
  Future<DataState> register({required RegistrationModel userModel}) async {
    try {
      dynamic data = await _registrationApiService.registerUser(userModel);
      if (data == null) {
        return DataSuccess(data);
      } else {
        return DataFailed(CustomException(message: data['message']));
      }
    } on CustomException catch (e) {
      return DataFailed(e);
    }
  }
}
