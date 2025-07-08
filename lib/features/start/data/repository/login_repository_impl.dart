import 'package:pecs_new_arch/core/network/custom_exceptions.dart';
import 'package:pecs_new_arch/core/resources/data_state.dart';
import 'package:pecs_new_arch/features/start/data/datasource/login_datasource.dart';
import 'package:pecs_new_arch/features/start/data/models/login_request_model.dart';
import 'package:pecs_new_arch/features/start/data/models/login_response_model.dart';
import 'package:pecs_new_arch/features/start/domain/repository/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginApiService _loginApiService;

  LoginRepositoryImpl(this._loginApiService);

  @override
  Future<DataState<LoginResponseModel>> login(
      {LoginRequestModel? loginUser}) async {
    try {
      var data = await _loginApiService.login(loginUser);
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
