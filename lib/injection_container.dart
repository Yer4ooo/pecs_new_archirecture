import 'package:get_it/get_it.dart';
import 'package:pecs_new_arch/core/utils/service_locator.dart';


final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  await setupKeyValueStorageService();
  setupApiService();
 
 

}
