import 'package:flutter/material.dart';
import 'package:pecs_new_arch/features/home/presentation/screens/widgets/home_bottom_widget.dart';
import 'package:pecs_new_arch/features/home/presentation/screens/widgets/home_top_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [HomeTopWidget(), HomeBottomWidget()],
          ),
        ),
      ),
    );
  }
}
