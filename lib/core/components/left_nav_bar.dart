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
                child: _ScreensExample(controller: _controller),
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

  const _ScreensExample({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return IndexedStack(
          index: controller.selectedIndex,
          children:  [
            ProfileScreen(),
            SizedBox.shrink(),
            BoardsScreen(), 
            Categories(),
            SizedBox.shrink(), // Placeholder for Analytics
            SizedBox.shrink(), // Placeholder for Settings
            SizedBox.shrink(), // Placeholder for Logout
          ],
        );
      },
    );
  }
}