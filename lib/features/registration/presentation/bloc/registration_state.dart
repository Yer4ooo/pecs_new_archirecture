part of 'registration_bloc.dart';

@freezed
class RegistrationState with _$RegistrationState {
  const factory RegistrationState.initial() = _Initial;
  const factory RegistrationState.registrationLoading() = RegistrationLoading;
  const factory RegistrationState.registrationFailure(CustomException message) = RegistrationFailure;

  // registration states
  const factory RegistrationState.registrationSuccess() = RegistrationSuccess;
}
