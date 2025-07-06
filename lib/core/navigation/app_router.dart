import 'package:auto_route/auto_route.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:pecs_new_arch/core/navigation/app_router.gr.dart';
import 'package:pecs_new_arch/core/utils/key_value_storage_service.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  NavigatorObserversBuilder get navigatorObservers =>
      () => [ChuckerFlutter.navigatorObserver];

  @override
  RouteType get defaultRouteType => RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: SidebarWrapper.page,
          path: '/dashboard',
          initial: true,
          guards: [AuthGuard()],
          children: [
            AutoRoute(
              page: ProfileRoute.page,
              path: 'profile',
              initial: true,
            ),
            // AutoRoute(
            //   page: ChildrenRoute.page, // You'll need to create this
            //   path: '/children',
            // ),
            AutoRoute(
              page: BoardsRoute.page,
              path: 'boards',
              children: [
                AutoRoute(
                  page: BoardsListRoute.page,
                  path: '',
                  initial: true,
                ),
                AutoRoute(
                  page: BoardRoute.page,
                  path: ':boardId',
                ),
              ],
            ),
            AutoRoute(
              page: Categories.page, // You'll need to create this
              path: 'library',
            ),
            // AutoRoute(
            //   page: AnalyticsRoute.page, // You'll need to create this
            //   path: '/analytics',
            // ),
            // AutoRoute(
            //   page: SettingsRoute.page, // You'll need to create this
            //   path: '/settings',
            // ),
          ],
        ),
        AutoRoute(
          page: StartRoute.page,
          path: '/start',
        ),
      ];
}

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final token = await GetIt.I<KeyValueStorageService>().getAccessToken();
    if (token != null) {
      resolver.next(true);
    } else {
      router.push(const StartRoute());
    }
  }
}
