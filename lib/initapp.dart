// import 'package:device_preview/device_preview.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get_it/get_it.dart';
import 'package:pecs_new_arch/core/theme/app_theme.dart';
import 'package:pecs_new_arch/core/utils/key_value_storage_service.dart';
import 'package:pecs_new_arch/features/home/presentation/screens/home_screen.dart';
import 'package:pecs_new_arch/features/library/presentation/bloc/library_bloc.dart';
import 'package:pecs_new_arch/features/login/presentation/bloc/login_bloc.dart';
import 'package:pecs_new_arch/features/registration/presentation/bloc/registration_bloc.dart';
import 'package:pecs_new_arch/features/start/presentation/start_page.dart';
import 'package:pecs_new_arch/injection_container.dart';


Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initializeDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<RegistrationBloc>()),
        BlocProvider(create: (_) => sl<LoginBloc>()),
        BlocProvider(create: (_) => sl<LibraryBloc>()),




      ],
      child: EasyLocalization(
        supportedLocales: const [
          Locale('ru'),
          Locale('kk'),
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('ru'),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(1200, 1920),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          navigatorObservers: [ChuckerFlutter.navigatorObserver],
          localizationsDelegates: context.localizationDelegates +
              [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          // builder: DevicePreview.appBuilder,
          // locale: DevicePreview.locale(context),
          debugShowCheckedModeBanner: false,
          theme: APP_THEME,
          home: FutureBuilder(
              future: GetIt.I<KeyValueStorageService>().getAccessToken(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(body: Center(child: CircularProgressIndicator.adaptive()));
                }
                return snapshot.hasData ? HomeScreen() : StartPage();//nav bar instead of sized box
              }),
        );
      },
    );
  }
}
