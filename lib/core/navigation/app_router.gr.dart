// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:flutter/material.dart' as _i9;
import 'package:pecs_new_arch/core/components/left_nav_bar.dart' as _i6;
import 'package:pecs_new_arch/features/board/presentation/screens/board.dart'
    as _i1;
import 'package:pecs_new_arch/features/board/presentation/screens/boards_list_screen.dart'
    as _i2;
import 'package:pecs_new_arch/features/board/presentation/screens/boards_screen.dart'
    as _i3;
import 'package:pecs_new_arch/features/library/presentation/screens/categories.dart'
    as _i4;
import 'package:pecs_new_arch/features/profile/presentation/screens/profile_screen.dart'
    as _i5;
import 'package:pecs_new_arch/features/start/presentation/start_page.dart'
    as _i7;

/// generated route for
/// [_i1.BoardScreen]
class BoardRoute extends _i8.PageRouteInfo<BoardRouteArgs> {
  BoardRoute({
    required String boardId,
    _i9.Key? key,
    List<_i8.PageRouteInfo>? children,
  }) : super(
          BoardRoute.name,
          args: BoardRouteArgs(boardId: boardId, key: key),
          initialChildren: children,
        );

  static const String name = 'BoardRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BoardRouteArgs>();
      return _i1.BoardScreen(boardId: args.boardId, key: args.key);
    },
  );
}

class BoardRouteArgs {
  const BoardRouteArgs({required this.boardId, this.key});

  final String boardId;

  final _i9.Key? key;

  @override
  String toString() {
    return 'BoardRouteArgs{boardId: $boardId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BoardRouteArgs) return false;
    return boardId == other.boardId && key == other.key;
  }

  @override
  int get hashCode => boardId.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i2.BoardsListScreen]
class BoardsListRoute extends _i8.PageRouteInfo<void> {
  const BoardsListRoute({List<_i8.PageRouteInfo>? children})
      : super(BoardsListRoute.name, initialChildren: children);

  static const String name = 'BoardsListRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i2.BoardsListScreen();
    },
  );
}

/// generated route for
/// [_i3.BoardsScreen]
class BoardsRoute extends _i8.PageRouteInfo<void> {
  const BoardsRoute({List<_i8.PageRouteInfo>? children})
      : super(BoardsRoute.name, initialChildren: children);

  static const String name = 'BoardsRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i3.BoardsScreen();
    },
  );
}

/// generated route for
/// [_i4.Categories]
class Categories extends _i8.PageRouteInfo<void> {
  const Categories({List<_i8.PageRouteInfo>? children})
      : super(Categories.name, initialChildren: children);

  static const String name = 'Categories';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i4.Categories();
    },
  );
}

/// generated route for
/// [_i5.ProfileScreen]
class ProfileRoute extends _i8.PageRouteInfo<void> {
  const ProfileRoute({List<_i8.PageRouteInfo>? children})
      : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i5.ProfileScreen();
    },
  );
}

/// generated route for
/// [_i6.SidebarWrapper]
class SidebarWrapper extends _i8.PageRouteInfo<void> {
  const SidebarWrapper({List<_i8.PageRouteInfo>? children})
      : super(SidebarWrapper.name, initialChildren: children);

  static const String name = 'SidebarWrapper';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return _i6.SidebarWrapper();
    },
  );
}

/// generated route for
/// [_i7.StartPage]
class StartRoute extends _i8.PageRouteInfo<void> {
  const StartRoute({List<_i8.PageRouteInfo>? children})
      : super(StartRoute.name, initialChildren: children);

  static const String name = 'StartRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i7.StartPage();
    },
  );
}
