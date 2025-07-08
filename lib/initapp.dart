// import 'package:device_preview/device_preview.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get_it/get_it.dart';
import 'package:pecs_new_arch/core/components/left_nav_bar.dart';
import 'package:pecs_new_arch/core/navigation/app_router.dart';
import 'package:pecs_new_arch/core/theme/app_theme.dart';
import 'package:pecs_new_arch/core/utils/key_value_storage_service.dart';
import 'package:pecs_new_arch/features/library/presentation/bloc/library_bloc.dart';
import 'package:pecs_new_arch/features/parent/presentation/bloc/parent_bloc.dart';
import 'package:pecs_new_arch/features/start/presentation/bloc/login_bloc.dart';
import 'package:pecs_new_arch/features/registration/presentation/bloc/registration_bloc.dart';
import 'package:pecs_new_arch/features/start/presentation/start_page.dart';
import 'package:pecs_new_arch/features/board/presentation/bloc/board_bloc.dart';
import 'package:pecs_new_arch/features/stickers/presentation/bloc/stickers_bloc.dart';
import 'package:pecs_new_arch/injection_container.dart';
import 'package:pecs_new_arch/translations/codegen_loader.g.dart';

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initializeDependencies();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  final appRouter = AppRouter();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<RegisterBloc>()),
        BlocProvider(create: (_) => sl<LoginBloc>()),
        BlocProvider(create: (_) => sl<LibraryBloc>()),
        BlocProvider(create: (_) => sl<BoardBloc>()),
        BlocProvider(create: (_) => sl<ParentBloc>()),
        BlocProvider(create: (_) => sl<StickersBloc>()),
      ],
      child: EasyLocalization(
        supportedLocales: const [
          Locale('ru'),
          Locale('kk'),
          Locale('en'),
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('ru'),
        assetLoader: CodegenLoader(),
        child: MyApp(appRouter: appRouter),
      ),
    ),
  );
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: Size(1024, 1366),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (context, child) {
//         return MaterialApp(
//           navigatorObservers: [ChuckerFlutter.navigatorObserver],
//           localizationsDelegates: context.localizationDelegates +
//               [
//                 GlobalMaterialLocalizations.delegate,
//                 GlobalWidgetsLocalizations.delegate,
//                 GlobalCupertinoLocalizations.delegate,
//               ],
//           supportedLocales: context.supportedLocales,
//           locale: context.locale,
//           // builder: DevicePreview.appBuilder,
//           // locale: DevicePreview.locale(context),
//           debugShowCheckedModeBanner: false,
//           theme: APP_THEME,
//           home: FutureBuilder(
//               future: GetIt.I<KeyValueStorageService>().getAccessToken(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Scaffold(
//                       body:
//                           Center(child: CircularProgressIndicator.adaptive()));
//                 }
//                 return snapshot.hasData
//                     ? SidebarWrapper()
//                     : StartPage(); //nav bar instead of sized box
//               }),
//         );
//       },
//     );
//   }
// }
class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1366, 1024),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          routerDelegate: appRouter.delegate(),
          routeInformationParser: appRouter.defaultRouteParser(),
          routeInformationProvider: appRouter.routeInfoProvider(),
          localizationsDelegates: context.localizationDelegates +
              [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          theme: APP_THEME,
        );
      },
    );
  }
}
