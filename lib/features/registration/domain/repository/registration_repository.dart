import 'package:pecs_new_arch/core/resources/data_state.dart';
import 'package:pecs_new_arch/features/registration/data/models/signup_request_model.dart';

abstract class RegistrationRepository {

  Future<DataState> register({
    required SignupRequestModel userModel,
  });

 

}