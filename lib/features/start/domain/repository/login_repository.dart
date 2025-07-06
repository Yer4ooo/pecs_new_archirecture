import 'package:pecs_new_arch/core/resources/data_state.dart';
import 'package:pecs_new_arch/features/start/data/models/login_request_model.dart';
import 'package:pecs_new_arch/features/start/data/models/login_response_model.dart';

abstract class LoginRepository {
  Future<DataState<LoginResponseModel>> login({LoginRequestModel? loginUser});
}
