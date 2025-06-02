import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pecs_new_arch/core/mixin/bloc_operations_mixin.dart';
import 'package:pecs_new_arch/core/network/custom_exceptions.dart';
import 'package:pecs_new_arch/features/registration/data/models/registration_model.dart';
import 'package:pecs_new_arch/features/registration/data/models/signup_request_model.dart';
import 'package:pecs_new_arch/features/registration/domain/usecases/registration_usecase.dart';
import 'package:pecs_new_arch/injection_container.dart';

part 'registration_event.dart';
part 'registration_state.dart';
part 'registration_bloc.freezed.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> with BlocEventHandlerMixin<RegistrationEvent, RegistrationState>{
  final RegistrationUsecase _registerUseCase = sl();
  RegistrationBloc() : super(_Initial()) {
    on<RegistrationEvent>((event, emit) async {
       await event.map(
     registerUser: (RegisterUser value) async => await handleEvent<dynamic>(
          operation: () async => await _registerUseCase.call(params: value.user),
          emit: emit,
          onLoading: RegistrationState.registrationLoading,
          onSuccess: (data) async => RegistrationState.registrationSuccess(),
          onFailure: (error) async => RegistrationState.registrationFailure(error),
        ),
      );
    
    });
  }
}
