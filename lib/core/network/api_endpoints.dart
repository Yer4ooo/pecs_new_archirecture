import 'package:flutter/material.dart';
import 'package:pecs_new_arch/core/constants/environment_config.dart';

@immutable
class ApiEndpoint {
  const ApiEndpoint._();
  static const String _baseUrlProd = 'https://api.hrilab.qys.kz/';
  static const String _baseUrlDev = 'https://api.hrilab.qys.kz/';

  static const String _baseUrlProxyProd = 'https://api.hrilab.qys.kz/';
  static const String _baseUrlProxyDev = 'https://api.hrilab.qys.kz/';

  static String get baseUrl =>
      EnvironmentConfig.isProduction ? _baseUrlProd : _baseUrlDev;
  static String get baseUrlProxy =>
      EnvironmentConfig.isProduction ? _baseUrlProxyProd : _baseUrlProxyDev;
}

enum AuthEndpoint {
  register('register'),
  login('login'),
  deleteAccount('delete-account');

  const AuthEndpoint(this.endpoint);
  final String endpoint;
  String get path => ApiEndpoint.baseUrlProxy;
}
