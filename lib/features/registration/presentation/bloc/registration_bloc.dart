import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pecs_new_arch/core/mixin/bloc_operations_mixin.dart';
import 'package:pecs_new_arch/core/network/custom_exceptions.dart';
import 'package:pecs_new_arch/features/start/data/models/login_request_model.dart';
import 'package:pecs_new_arch/features/start/data/models/login_response_model.dart';
import 'package:pecs_new_arch/features/start/domain/usecase/login_usecase.dart';
import 'package:pecs_new_arch/injection_container.dart';

import '../../data/models/registration_request_model.dart';
import '../../data/models/registration_success_response_model.dart';
import '../../domain/usecases/registration_usecase.dart';

part 'registration_event.dart';
part 'registration_state.dart';
part 'registration_bloc.freezed.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState>
    with BlocEventHandlerMixin<RegisterEvent, RegisterState> {
  final RegisterUsecase _registerUsecase = sl();
  RegisterBloc() : super(_Initial()) {
    on<RegisterEvent>((event, emit) async {
      await event.map(
        register: (Register user) async => await handleEvent<RegisterResponseModel>(
          operation: () async => await _registerUsecase.call(params: user.user),
          emit: emit,
          onLoading: RegisterState.registerLoading,
          onSuccess: (data) async => RegisterState.registerSuccess(data),
          onFailure: (error) async => RegisterState.registerFailure(error),
        ),
      );
    });
  }
}
