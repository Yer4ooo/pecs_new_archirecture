import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:pecs_new_arch/core/constants/app_icons.dart';
import 'package:pecs_new_arch/core/navigation/app_router.gr.dart';
import 'package:pecs_new_arch/core/utils/key_value_storage_service.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../translations/locale_keys.g.dart';

@RoutePage()
class SidebarWrapper extends StatefulWidget {
  @override
  State<SidebarWrapper> createState() => _SidebarWrapperState();
}

class _SidebarWrapperState extends State<SidebarWrapper> with RouteAware {
  String userName = 'Loading...';
  final _controller = SidebarXController(selectedIndex: 0, extended: false);
  bool _shouldHideSidebar = false;
  bool _showingSidebarTemporarily = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
    loadUserData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkCurrentRoute();
    });
  }

  Future<void> loadUserData() async {
    final userData = await GetIt.I<KeyValueStorageService>().getUserData();
    setState(() {
      userName = userData!.displayName;
    });
  }

  void _checkCurrentRoute() {
    try {
      final tabsRouter = AutoTabsRouter.of(context);
      bool shouldHide = false;

      if (tabsRouter.activeIndex == 1) {
        final currentRouter =
            tabsRouter.innerRouterOf('BoardsRoute') as StackRouter?;
        final currentRouteName = currentRouter?.current.name;
        shouldHide = currentRouteName == 'BoardRoute';
      }
      if (shouldHide != _shouldHideSidebar) {
        setState(() {
          _shouldHideSidebar = shouldHide;
        });
      }
    } catch (e) {
      print('AutoTabsRouter not available: $e');
    }
  }

  void _checkCurrentRouteSync(BuildContext context) {
    try {
      final tabsRouter = AutoTabsRouter.of(context);
      bool shouldHide = false;
      if (tabsRouter.activeIndex == 1) {
        final currentRouter =
            tabsRouter.innerRouterOf('BoardsRoute') as StackRouter?;
        final currentRouteName = currentRouter?.current.name;
        shouldHide = currentRouteName == 'BoardRoute';
      }
      if (shouldHide != _shouldHideSidebar) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _shouldHideSidebar = shouldHide;
            });
          }
        });
      }
    } catch (e) {
      print('AutoTabsRouter not available: $e');
    }
  }

  void _showTemporarySidebar() {
    setState(() {
      _showingSidebarTemporarily = true;
    });
  }

  void _hideTemporarySidebar() {
    setState(() {
      _showingSidebarTemporarily = false;
      _controller.setExtended(false);
    });
  }

  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocaleKeys.left_nav_confirm_logout.tr()),
        content: Text(LocaleKeys.left_nav_logout.tr()),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                LocaleKeys.left_nav_cancel.tr(),
              )),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                LocaleKeys.left_nav_log_out.tr(),
                style: TextStyle(color: Colors.red),
              )),
        ],
      ),
    );
    if (shouldLogout == true) {
      GetIt.I<KeyValueStorageService>().resetKeys();
      context.router.replace(const StartRoute());
    }
  }

  Widget _buildSidebar() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final width = _controller.extended ? 319.0.w : 88.0.w;
        return SizedBox(
            width: width,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: !_controller.extended
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          offset: Offset(2, 0),
                          blurRadius: 2,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: Material(
                elevation: 0,
                child: SidebarX(
                  controller: _controller,
                  showToggleButton: false,
                  headerBuilder: (context, extended) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 88.w,
                              child: Center(
                                child: IconButton(
                                  icon: SvgPicture.asset(AppIcons.sidebar),
                                  onPressed: () {
                                    _controller.setExtended(!extended);
                                  },
                                ),
                              ),
                            ),
                            Expanded(child: SizedBox())
                          ],
                        ),
                        8.verticalSpace,
                        Row(
                          children: [
                            SizedBox(
                                width: 88.w,
                                child: Center(
                                  child: CircleAvatar(
                                    radius: 30.r,
                                    child:
                                        Image.asset('assets/images/avatar.png'),
                                  ),
                                )),
                            extended
                                ? Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          userName,
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          '',
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              color: Colors.grey),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  )
                                : Expanded(child: SizedBox())
                          ],
                        ),
                        10.verticalSpace,
                      ],
                    );
                  },
                  theme: SidebarXTheme(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20).r,
                    ),
                    selectedTextStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFF619451)),
                    itemTextPadding: EdgeInsets.only(left: 30).w,
                    selectedItemTextPadding: EdgeInsets.only(left: 30).w,
                    selectedItemDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10).r,
                      border: Border.all(
                        color: Color(0xFF619451),
                      ),
                    ),
                  ),
                  extendedTheme: SidebarXTheme(
                    width: 319.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                  ),
                  headerDivider: Divider(
                    color: Colors.black.withOpacity(0.3),
                    height: 1.h,
                    indent: 10.w,
                    endIndent: 10.w,
                  ),
                  items: [
                    SidebarXItem(
                      iconWidget: SvgPicture.asset(
                        AppIcons.person,
                        color: _controller.selectedIndex == 0
                            ? const Color(0xFF619451)
                            : Colors.grey.shade600,
                      ),
                      label: LocaleKeys.left_nav_profile.tr(),
                      onTap: () {
                        AutoTabsRouter.of(context).setActiveIndex(0);
                        if (_showingSidebarTemporarily) {
                          _hideTemporarySidebar();
                        }
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _checkCurrentRoute();
                        });
                      },
                    ),
                    SidebarXItem(
                      iconWidget: SvgPicture.asset(
                        AppIcons.people,
                        color: _controller.selectedIndex == 1
                            ? const Color(0xFF619451)
                            : Colors.grey.shade600,
                      ),
                      selectable: false,
                      label: LocaleKeys.left_nav_children.tr(),
                    ),
                    SidebarXItem(
                        iconWidget: SvgPicture.asset(
                          AppIcons.boards,
                          color: _controller.selectedIndex == 2
                              ? const Color(0xFF619451)
                              : Colors.grey.shade600,
                        ),
                        label: LocaleKeys.left_nav_boards.tr(),
                        onTap: () {
                          final tabsRouter = AutoTabsRouter.of(context);
                          if (tabsRouter.activeIndex != 1) {
                            tabsRouter.setActiveIndex(1);
                          } else {
                            final currentRouter = tabsRouter
                                .innerRouterOf('BoardsRoute') as StackRouter?;

                            final currentRouteName =
                                currentRouter?.current.name;

                            if (currentRouteName == 'BoardRoute') {
                              currentRouter?.replace(BoardsListRoute());
                            }
                          }
                          if (_showingSidebarTemporarily) {
                            _hideTemporarySidebar();
                          }
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _checkCurrentRoute();
                          });
                        }),
                    SidebarXItem(
                      iconWidget: SvgPicture.asset(
                        AppIcons.book,
                        color: _controller.selectedIndex == 3
                            ? const Color(0xFF619451)
                            : Colors.grey.shade600,
                      ),
                      label: LocaleKeys.left_nav_library.tr(),
                      onTap: () {
                        AutoTabsRouter.of(context).setActiveIndex(2);
                        if (_showingSidebarTemporarily) {
                          _hideTemporarySidebar();
                        }
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _checkCurrentRoute();
                        });
                      },
                    ),
                    SidebarXItem(
                      iconWidget: SvgPicture.asset(
                        AppIcons.analysis,
                        color: _controller.selectedIndex == 4
                            ? const Color(0xFF619451)
                            : Colors.grey.shade600,
                      ),
                      label: LocaleKeys.left_nav_analytics.tr(),
                      selectable: false,
                    ),
                    SidebarXItem(
                      iconWidget: SvgPicture.asset(
                        AppIcons.settings,
                        color: _controller.selectedIndex == 5
                            ? const Color(0xFF619451)
                            : Colors.grey.shade600,
                      ),
                      label: LocaleKeys.left_nav_settings.tr(),
                      selectable: false,
                    ),
                    SidebarXItem(
                      iconWidget: SvgPicture.asset(
                        AppIcons.logout,
                        color: _controller.selectedIndex == 6
                            ? const Color(0xFF619451)
                            : Colors.grey.shade600,
                      ),
                      label: LocaleKeys.left_nav_log_out.tr(),
                      onTap: () {
                        if (_showingSidebarTemporarily) {
                          _hideTemporarySidebar();
                        }
                        _handleLogout();
                      },
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.pageView(
      physics: const NeverScrollableScrollPhysics(),
      routes: [
        ProfileRoute(),
        BoardsRoute(),
        Categories(),
      ],
      builder: (context, child, animation) {
        _checkCurrentRouteSync(context);

        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: _shouldHideSidebar ? 0 : 88.w,
                  right: 0,
                  child: child,
                ),
                if (_shouldHideSidebar)
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    width: 20.w,
                    child: GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        if (details.delta.dx > 0) {
                          _showTemporarySidebar();
                        }
                      },
                      onTap: () {
                        _showTemporarySidebar();
                      },
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                if (_controller.extended && !_shouldHideSidebar)
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () => _controller.setExtended(false),
                      child: Container(color: Colors.black.withOpacity(0.2)),
                    ),
                  ),
                if (_shouldHideSidebar && _showingSidebarTemporarily)
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () => _hideTemporarySidebar(),
                      onHorizontalDragUpdate: (details) {
                        // Hide on left swipe
                        if (details.delta.dx < -5) {
                          _hideTemporarySidebar();
                        }
                      },
                      child: Container(color: Colors.black.withOpacity(0.3)),
                    ),
                  ),
                if (!_shouldHideSidebar ||
                    (_shouldHideSidebar && _showingSidebarTemporarily))
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    child: GestureDetector(
                      onHorizontalDragUpdate: _shouldHideSidebar
                          ? (details) {
                              if (details.delta.dx < -5) {
                                _hideTemporarySidebar();
                              }
                            }
                          : null,
                      child: _buildSidebar(),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
