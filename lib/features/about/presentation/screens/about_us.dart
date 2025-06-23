import 'package:flutter/material.dart';
import 'package:pecs_new_arch/features/about/presentation/widgets/about_us_bottom.dart';
import 'package:pecs_new_arch/features/about/presentation/widgets/about_us_middle.dart';
import 'package:pecs_new_arch/features/about/presentation/widgets/about_us_top.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor:  Colors.white,
      body:  SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AboutUsTop(),
              AboutUsMiddle(),
              AboutUsBottom()
            ],
          ),
        ),
      ),
    );
  }
}
