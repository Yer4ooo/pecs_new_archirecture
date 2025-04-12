// Env Configs
import 'package:flutter/foundation.dart';

enum Flavor {
  development,
  production,
}

class EnvironmentConfig {
  static Flavor? flavor;
  static String? fcmApiKey;

  static bool get isProduction => flavor == Flavor.production;

  static bool get isDevelopment => flavor == Flavor.development;

  static bool get isDebug => !kReleaseMode;

  static bool get shouldLogCrashlytics => !isDebug;
}
