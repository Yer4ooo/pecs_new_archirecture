import 'package:pecs_new_arch/core/network/api_endpoints.dart';
import 'package:pecs_new_arch/core/network/network_client.dart';
import 'package:pecs_new_arch/features/registration/data/models/registration_model.dart';
import 'package:pecs_new_arch/features/registration/data/models/signup_request_model.dart';
import 'package:pecs_new_arch/injection_container.dart';

class RegistrationApiService {
  RegistrationApiService();
  final NetworkClient _networkClient = sl.get<NetworkClient>();

  Future<dynamic> registerUser(RegistrationModel? user) => _networkClient.postData(
        baseurl: AuthEndpoint.register.path,
        endpoint: 'registration-email',
        body: {
        "role": user?.role,
"email": user?.email,
          "first_name": user?.firstName,
          "last_name": user?.lastName,
          "password": user?.password,
            "phone": user?.phone,
          "address": user?.address,
                    "specialization": user?.specialization,
          "org_name": user?.orgName,
          "bin": user?.bin,
          
          
        },
        parser: null,
      );
}
