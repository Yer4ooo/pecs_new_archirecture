import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:pecs_new_arch/core/constants/app_icons.dart';
import 'package:pecs_new_arch/core/utils/key_value_storage_service.dart';
import 'package:pecs_new_arch/features/library/presentation/screens/categories.dart';
import 'package:pecs_new_arch/features/profile/presentation/screens/profile_screen.dart';
import 'package:pecs_new_arch/features/start/presentation/start_page.dart';
import 'package:pecs_new_arch/features/board/presentation/screens/boards_screen.dart';
import 'package:sidebarx/sidebarx.dart';

class SidebarWrapper extends StatefulWidget {
  @override
  State<SidebarWrapper> createState() => _SidebarWrapperState();
}

class _SidebarWrapperState extends State<SidebarWrapper> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final GlobalKey<NavigatorState> boardNavigateKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> categoriesNavigatorKey =
      GlobalKey<NavigatorState>();
  int _previousSelectedIndex = 0;
  bool _wasExtended = true;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      final currentIndex = _controller.selectedIndex;
      final isExtended = _controller.extended;
      if (_wasExtended != isExtended) {
        _wasExtended = isExtended;
        return;
      }
      if (currentIndex == _previousSelectedIndex) {
        if (currentIndex == 2) {
          boardNavigateKey.currentState?.popUntil((route) => route.isFirst);
        } else if (currentIndex == 3) {
          categoriesNavigatorKey.currentState
              ?.popUntil((route) => route.isFirst);
        }
      }
      _previousSelectedIndex = currentIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SidebarX(
              controller: _controller,
              showToggleButton: true,
              headerBuilder: (context, extended) {
                return Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/avatar.png'),
                    ),
                    if (extended) const SizedBox(width: 8),
                    if (extended)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Алина',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'alina',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
              theme: SidebarXTheme(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                selectedItemDecoration: BoxDecoration(
                  color: Color(0xFFE7F1E8),
                  borderRadius: BorderRadius.circular(10),
                ),
                itemTextPadding: const EdgeInsets.symmetric(horizontal: 16),
                iconTheme: IconThemeData(color: Colors.grey),
                selectedIconTheme:
                    const IconThemeData(color: Color(0xFF619451)),
                itemPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              extendedTheme: const SidebarXTheme(
                width: 250,
                decoration: BoxDecoration(color: Colors.white),
              ),
              items: [
                SidebarXItem(
                  iconWidget: SvgPicture.asset(
                    AppIcons.person,
                    color: Colors.grey.shade600,
                  ),
                  label: 'Мой профиль',
                ),
                SidebarXItem(
                  iconWidget: SvgPicture.asset(AppIcons.people),
                  label: 'Мои дети',
                ),
                SidebarXItem(
                  iconWidget: SvgPicture.asset(AppIcons.boards),
                  label: 'Мои доски',
                ),
                SidebarXItem(
                  iconWidget: SvgPicture.asset(AppIcons.book),
                  label: 'Библиотека',
                ),
                SidebarXItem(
                  iconWidget: SvgPicture.asset(AppIcons.analysis),
                  label: 'Аналитика',
                ),
                SidebarXItem(
                  iconWidget: SvgPicture.asset(AppIcons.settings),
                  label: 'Настройки',
                ),
                SidebarXItem(
                    iconWidget: SvgPicture.asset(AppIcons.logout),
                    label: 'Выйти',
                    onTap: () {
                      GetIt.I<KeyValueStorageService>().resetKeys();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StartPage(),
                        ),
                        (route) => false,
                      );
                    }),
              ],
            ),
            Expanded(
              child: Center(
                  child: _ScreensExample(
                controller: _controller,
                boardNavigatorKey: boardNavigateKey,
                categoriesNavigatorKey: categoriesNavigatorKey,
              )),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScreensExample extends StatelessWidget {
  final SidebarXController controller;
  final GlobalKey<NavigatorState> boardNavigatorKey;
  final GlobalKey<NavigatorState> categoriesNavigatorKey;

  const _ScreensExample({
    required this.controller,
    required this.boardNavigatorKey,
    required this.categoriesNavigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Stack(
          children: [
            Offstage(
              offstage: controller.selectedIndex != 0,
              child: const ProfileScreen(),
            ),
            Offstage(
              offstage: controller.selectedIndex != 1,
              child: const SizedBox.shrink(),
            ),
            Offstage(
              offstage: controller.selectedIndex != 2,
              child: Navigator(
                key: boardNavigatorKey,
                onGenerateRoute: (_) => MaterialPageRoute(
                  builder: (context) => BoardsScreen(
                    key: UniqueKey(),
                    navigatorKey: boardNavigatorKey,
                  ),
                ),
              ),
            ),
            Offstage(
              offstage: controller.selectedIndex != 3,
              child: Navigator(
                key: categoriesNavigatorKey,
                onGenerateRoute: (_) => MaterialPageRoute(
                  builder: (_) => Categories(
                    key: UniqueKey(),
                    navigatorKey: categoriesNavigatorKey,
                  ),
                ),
              ),
            ),
            Offstage(
              offstage: controller.selectedIndex != 4,
              child: const SizedBox.shrink(), // Аналитика
            ),
            Offstage(
              offstage: controller.selectedIndex != 5,
              child: const SizedBox.shrink(), // Настройки
            ),
          ],
        );
      },
    );
  }
}
