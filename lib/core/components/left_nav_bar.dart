import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:pecs_new_arch/core/constants/app_icons.dart';
import 'package:pecs_new_arch/core/utils/key_value_storage_service.dart';
import 'package:pecs_new_arch/features/board/screens/boards_screen.dart';
import 'package:pecs_new_arch/features/library/presentation/screens/categories.dart';
import 'package:pecs_new_arch/features/profile/presentation/screens/profile_screen.dart';
import 'package:pecs_new_arch/features/start/presentation/start_page.dart';
import 'package:sidebarx/sidebarx.dart';

class SidebarWrapper extends StatefulWidget {
  @override
  State<SidebarWrapper> createState() => _SidebarWrapperState();
}

class _SidebarWrapperState extends State<SidebarWrapper> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
final GlobalKey<NavigatorState> _nestedNavigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> categoriesNavigatorKey=GlobalKey<NavigatorState>();

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
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/avatar.png'), // Add your asset
                    ),
                    Column(
                    children: [
                    if (extended) ...[
                      const SizedBox(height: 10),
                      const Text(
                        'Алина Аскарова',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'alina.askarova@gmail.com',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                    ],
                    ],)
                    
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
                selectedIconTheme: const IconThemeData(color: Color(0xFF619451)),
                itemPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              extendedTheme: const SidebarXTheme(
                width: 280,
                decoration: BoxDecoration(color: Colors.white),
              ),
              items: [
                SidebarXItem(
                  iconWidget: SvgPicture.asset(AppIcons.person,color: Colors.grey.shade600,),
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
                  onTap: (){
                  
                   GetIt.I<KeyValueStorageService>().resetKeys();
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const StartPage(),
                                        ),
                                        (route) => false,
                                      );}
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: _ScreensExample(controller: _controller,
                  boardNavigatorKey: _nestedNavigatorKey, 
                  categoriesNavigatorKey: categoriesNavigatorKey,)// Pass the nested navigator key),
              ),
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
              child: const SizedBox.shrink(), // Мои дети
            ),
            Offstage(
              offstage: controller.selectedIndex != 2,
              child: Navigator(
                key: boardNavigatorKey,
                onGenerateRoute: (_) => MaterialPageRoute(
                  builder: (_) => BoardsScreen(navigatorKey: boardNavigatorKey),
                ),
              ),
            ),
            Offstage(
              offstage: controller.selectedIndex != 3,
              child: Navigator(
                key: categoriesNavigatorKey,
                onGenerateRoute: (_) => MaterialPageRoute(
                  builder: (_) => Categories(navigatorKey: categoriesNavigatorKey),
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
