import 'package:get_it/get_it.dart';
import 'package:pecs_new_arch/core/network/api_endpoints.dart';
import 'package:pecs_new_arch/core/network/network_client.dart';
import 'package:pecs_new_arch/core/utils/key_value_storage_service.dart';
import 'package:pecs_new_arch/features/login/data/models/login_request_model.dart';
import 'package:pecs_new_arch/features/login/data/models/login_response_model.dart';
import 'package:pecs_new_arch/injection_container.dart';

class LoginApiService {
  LoginApiService();
  final NetworkClient _networkClient = sl.get<NetworkClient>();

  Future<dynamic> login(LoginRequestModel? user) => _networkClient.postData<LoginResponseModel>(
        baseurl: AuthEndpoint.login.path,
        endpoint: 'login',
        body: {'username': user?.username, 'password': user?.password},
        parser: (response) {
          GetIt.I<KeyValueStorageService>().setUserData(loginResponseModelToJson(LoginResponseModel.fromJson(response)));
          GetIt.I<KeyValueStorageService>().setAccessToken(response['access']);
          return LoginResponseModel.fromJson(response);
        },
      );
}
