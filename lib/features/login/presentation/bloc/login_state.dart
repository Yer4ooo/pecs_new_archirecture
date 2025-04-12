part of 'login_bloc.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial() = _Initial;
  const factory LoginState.loginLoading() = LoginLoading;
  const factory LoginState.loginFailure(CustomException message) = LoginFailure;
  const factory LoginState.loginSuccess(LoginResponseModel user) = LoginSuccess;
}
