import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pecs_new_arch/core/mixin/bloc_operations_mixin.dart';
import 'package:pecs_new_arch/core/network/custom_exceptions.dart';
import 'package:pecs_new_arch/features/start/data/models/login_request_model.dart';
import 'package:pecs_new_arch/features/start/data/models/login_response_model.dart';
import 'package:pecs_new_arch/features/start/domain/usecase/login_usecase.dart';
import 'package:pecs_new_arch/injection_container.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> with BlocEventHandlerMixin<LoginEvent, LoginState>{
  final LoginUsecase _loginUsecase = sl();
  LoginBloc() : super(_Initial()) {
    on<LoginEvent>((event, emit) async {
      await event.map(
        login: (Login user) async => await handleEvent<LoginResponseModel>(
          operation: () async => await _loginUsecase.call(params: user.user),
          emit: emit,
          onLoading: LoginState.loginLoading,
          onSuccess: (data) async => LoginState.loginSuccess(data),
          onFailure: (error) async => LoginState.loginFailure(error),
        ),
      );
    });
  }
}
