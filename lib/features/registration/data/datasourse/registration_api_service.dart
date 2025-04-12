import 'package:pecs_new_arch/core/network/api_endpoints.dart';
import 'package:pecs_new_arch/core/network/network_client.dart';
import 'package:pecs_new_arch/features/registration/data/models/signup_request_model.dart';
import 'package:pecs_new_arch/injection_container.dart';

class RegistrationApiService {
  RegistrationApiService();
  final NetworkClient _networkClient = sl.get<NetworkClient>();

  Future<dynamic> registerUser(SignupRequestModel? user) => _networkClient.postData(
        baseurl: AuthEndpoint.register.path,
        endpoint: 'signup',
        body: {
          "username": user?.username,
          "password": user?.password,
          "email": user?.email,
          "first_name": user?.firstName,
          "last_name": user?.lastName,
          "role": user?.role
        },
        parser: null,
      );
}
