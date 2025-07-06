part of 'registration_bloc.dart';

@freezed
class RegisterState with _$RegisterState {
  const factory RegisterState.initial() = _Initial;
  const factory RegisterState.registerLoading() = RegisterLoading;
  const factory RegisterState.registerFailure(CustomException message) = RegisterFailure;
  const factory RegisterState.registerSuccess(RegisterResponseModel user) = RegisterSuccess;
}
