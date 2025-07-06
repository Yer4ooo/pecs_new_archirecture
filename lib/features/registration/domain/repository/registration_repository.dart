import 'package:pecs_new_arch/core/resources/data_state.dart';

import '../../data/models/registration_request_model.dart';
import '../../data/models/registration_success_response_model.dart';

abstract class RegisterRepository {
  Future<DataState<RegisterResponseModel>> register({required RegisterRequestModel registerUser});
}
