import 'package:get_it/get_it.dart';
import 'package:pecs_new_arch/core/utils/service_locator.dart';
import 'package:pecs_new_arch/features/board/logic/bloc/board_bloc.dart';
import 'package:pecs_new_arch/features/children/logic/bloc/children_bloc.dart';
import 'package:pecs_new_arch/features/library/data/datasource/library_api_service.dart';
import 'package:pecs_new_arch/features/library/data/repository/library_repo_impl.dart';
import 'package:pecs_new_arch/features/library/domain/repository/library_repository.dart';
import 'package:pecs_new_arch/features/library/domain/usecases/create_category_usecase.dart';
import 'package:pecs_new_arch/features/library/domain/usecases/create_image_usecase.dart';
import 'package:pecs_new_arch/features/library/domain/usecases/get_categories_usecase.dart';
import 'package:pecs_new_arch/features/library/domain/usecases/get_category_images_usecase.dart';
import 'package:pecs_new_arch/features/library/presentation/bloc/library_bloc.dart';
import 'package:pecs_new_arch/features/start/data/datasource/login_datasource.dart';
import 'package:pecs_new_arch/features/start/data/repository/login_repository_impl.dart';
import 'package:pecs_new_arch/features/start/domain/repository/login_repository.dart';
import 'package:pecs_new_arch/features/start/domain/usecase/login_usecase.dart';
import 'package:pecs_new_arch/features/start/presentation/bloc/login_bloc.dart';
import 'package:pecs_new_arch/features/registration/data/datasourse/registration_api_service.dart';
import 'package:pecs_new_arch/features/registration/data/repository/registration_repo_impl.dart';
import 'package:pecs_new_arch/features/registration/domain/repository/registration_repository.dart';
import 'package:pecs_new_arch/features/registration/domain/usecases/registration_usecase.dart';
import 'package:pecs_new_arch/features/registration/presentation/bloc/registration_bloc.dart';


final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  await setupKeyValueStorageService();
  setupApiService();


  sl.registerFactory<RegistrationBloc>(() => RegistrationBloc());
  sl.registerSingleton<RegistrationApiService>(RegistrationApiService());
  sl.registerSingleton<RegistrationRepository>(RegistrationRepositoryImpl(sl()));
  sl.registerSingleton<RegistrationUsecase>(RegistrationUsecase(sl()));

  sl.registerFactory<LoginBloc>(() => LoginBloc());
  sl.registerSingleton<LoginApiService>(LoginApiService());
  sl.registerSingleton<LoginRepository>(LoginRepositoryImpl(sl()));
  sl.registerSingleton<LoginUsecase>(LoginUsecase(sl()));

  sl.registerFactory<LibraryBloc>(() => LibraryBloc());
  sl.registerSingleton<LibraryApiService>(LibraryApiService());
  sl.registerSingleton<LibraryRepository>(LibraryRepoImpl(sl()));
  sl.registerSingleton<CreateCategoryUsecase>(CreateCategoryUsecase(sl()));
  sl.registerSingleton<CreateImageUsecase>(CreateImageUsecase(sl()));
  sl.registerSingleton<GetCategoriesUsecase>(GetCategoriesUsecase(sl()));
  sl.registerSingleton<GetCategoryImagesUsecase>(GetCategoryImagesUsecase(sl()));

  //board
  sl.registerFactory<BoardBloc>(() => BoardBloc());
  sl.registerFactory<ChildrenBloc>(() => ChildrenBloc());








 
 

}
