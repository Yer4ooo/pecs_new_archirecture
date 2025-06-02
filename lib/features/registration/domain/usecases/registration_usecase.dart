import 'package:pecs_new_arch/core/resources/data_state.dart';
import 'package:pecs_new_arch/core/usecase/usecase.dart';
import 'package:pecs_new_arch/features/registration/data/models/registration_model.dart';
import 'package:pecs_new_arch/features/registration/data/models/signup_request_model.dart';
import 'package:pecs_new_arch/features/registration/domain/repository/registration_repository.dart';

class RegistrationUsecase implements UseCase<DataState, RegistrationModel?> {
  final RegistrationRepository _registrationRepository;

  RegistrationUsecase(this._registrationRepository);

  @override
  Future<DataState> call({RegistrationModel? params}) async {
    return await _registrationRepository.register(userModel: params!);
  }
}