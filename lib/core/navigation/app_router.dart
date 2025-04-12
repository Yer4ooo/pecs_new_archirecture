// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
// import 'package:my_clean_architecture/features/authentication/presentation/bloc/global_auth/global_auth_bloc.dart';
// import 'package:my_clean_architecture/features/authentication/presentation/page/auth_page.dart';
// import 'package:my_clean_architecture/features/home/presentation/page/home_page.dart';
// import 'package:my_clean_architecture/features/home/presentation/page/post_detail.dart';

// part 'app_router.gr.dart';

// class AuthGuard extends AutoRouteGuard {
//   @override
//   void onNavigation(NavigationResolver resolver, StackRouter router) {
//     final authenticated = GetIt.I<GlobalAuthBloc>().state.status == GlobalAuthStatus.authenticated;
//     if (authenticated) {
//       resolver.next(true);
//     } else {
//       resolver.next(false);

//       resolver.redirect(AuthRoute());
//     }
//   }
// }

// @AutoRouterConfig(replaceInRouteName: 'Page,Route')
// class AppRouter extends _$AppRouter {
//   @override
//   List<AutoRoute> get routes => [
//         AutoRoute(page: AuthRoute.page),
//         AutoRoute(page: HomeRoute.page, initial: true),
//         AutoRoute(page: PostDetailRoute.page),
//       ];
// }
