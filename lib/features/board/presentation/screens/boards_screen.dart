import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class BoardsScreen extends StatelessWidget {
  const BoardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoRouter();
  }
}
