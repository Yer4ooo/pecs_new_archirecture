import 'package:pecs_new_arch/core/resources/data_state.dart';
import 'package:pecs_new_arch/core/usecase/usecase.dart';
import 'package:pecs_new_arch/features/start/data/models/login_request_model.dart';
import 'package:pecs_new_arch/features/start/domain/repository/login_repository.dart';
import 'package:pecs_new_arch/features/start/data/models/login_response_model.dart';

class LoginUsecase implements UseCase<DataState<LoginResponseModel>, LoginRequestModel?> {
  final LoginRepository _loginRepository;

  LoginUsecase(this._loginRepository);

  @override
  Future<DataState<LoginResponseModel>> call({LoginRequestModel? params}) async {
    return await _loginRepository.login(loginUser: params!);
  }
}
