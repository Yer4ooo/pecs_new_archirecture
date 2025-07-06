part of 'registration_bloc.dart';


@freezed
class RegisterEvent with _$RegisterEvent {
  const factory RegisterEvent.register({required RegisterRequestModel user}) = Register;
}