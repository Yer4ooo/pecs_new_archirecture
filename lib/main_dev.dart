import 'package:chucker_flutter/chucker_flutter.dart';

import 'package:pecs_new_arch/core/constants/environment_config.dart';
import 'package:pecs_new_arch/initapp.dart';

Future<void> main() async {
  ChuckerFlutter.showOnRelease = true;
  EnvironmentConfig.flavor = Flavor.development;
  await initApp();
}
