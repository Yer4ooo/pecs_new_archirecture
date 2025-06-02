// To parse this JSON data, do
//
//     final registrationModel = registrationModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'registration_model.freezed.dart';
part 'registration_model.g.dart';

RegistrationModel registrationModelFromJson(String str) => RegistrationModel.fromJson(json.decode(str));

String registrationModelToJson(RegistrationModel data) => json.encode(data.toJson());

@freezed
class RegistrationModel with _$RegistrationModel {
 @JsonSerializable(fieldRename: FieldRename.snake)
    const factory RegistrationModel({
        String? role,
        String? email,
        String? firstName,
        String? lastName,
        String? password,
        String? phone,
        String? address,
        String? specialization,
        String? description,
        String? orgName,
        String? bin,
    }) = _RegistrationModel;

    factory RegistrationModel.fromJson(Map<String, dynamic> json) => _$RegistrationModelFromJson(json);
}
