import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:pecs_new_arch/core/network/network_client.dart';
import 'package:pecs_new_arch/core/utils/key_value_storage_service.dart';
import 'package:pecs_new_arch/injection_container.dart';

import '../models/registration_request_model.dart';
import '../models/registration_success_response_model.dart';

class RegisterApiService {
  RegisterApiService();

  final NetworkClient _networkClient = sl.get<NetworkClient>();

  Future<RegisterResponseModel?> register(RegisterRequestModel user) {
    return _networkClient.postFormData<RegisterResponseModel>(
      endpoint: 'registration-email',
      formData: FormData.fromMap(user.toFormData()),
      parser: (response) {
        if (response['username'] != null) {
          GetIt.I<KeyValueStorageService>().setUserData(response.toString());
        }
        return RegisterResponseModel.fromJson(response);
      },
    );
  }
}
