part of 'registration_bloc.dart';

@freezed
class RegistrationEvent with _$RegistrationEvent {
    const factory RegistrationEvent.registerUser({ RegistrationModel? user}) = RegisterUser;
}