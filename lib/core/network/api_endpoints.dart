import 'package:flutter/material.dart';
import 'package:pecs_new_arch/core/constants/environment_config.dart';

@immutable
class ApiEndpoint {
  const ApiEndpoint._();

  /// Base URL selection based on environment
  static const String _baseUrlProd = 'http://86.107.199.109/';
  static const String _baseUrlDev = 'http://86.107.199.109/';

  static const String _baseUrlProxyProd = 'http://86.107.199.109/';
  static const String _baseUrlProxyDev = 'http://86.107.199.109/';

  static String get baseUrl => EnvironmentConfig.isProduction ? _baseUrlProd : _baseUrlDev;
  static String get baseUrlProxy => EnvironmentConfig.isProduction ? _baseUrlProxyProd : _baseUrlProxyDev;
}

enum AuthEndpoint {
  register('register'),
  login('login'),
  deleteAccount('delete-account');

  const AuthEndpoint(this.endpoint);
  final String endpoint;

  /// Getter to return full API path based on the environment
  String get path => ApiEndpoint.baseUrlProxy;
}
