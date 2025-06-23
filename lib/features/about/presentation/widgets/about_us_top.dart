// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AboutUsTop extends StatefulWidget {
  const AboutUsTop({super.key});

  @override
  State<AboutUsTop> createState() => _AboutUsTopState();
}

class _AboutUsTopState extends State<AboutUsTop> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 100),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                color: Color.fromRGBO(246, 250, 245, 1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Color.fromRGBO(87, 156, 163, 1),
                ),
              ),
              child: const Center(
                child: Text(
                  'Наши преимущества',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(87, 156, 163, 1),
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            const Text(
              'Преимущества платформы SӨYLEM',
              style: TextStyle(
                color: Color.fromRGBO(87, 156, 163, 1),
                fontSize: 30,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            // First row of ImageTextContainers
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageTextContainer(
                  assetImagePath: 'assets/jpg/icon4.jpg',
                  firstText: 'Индивидуальные настройки',
                  secondText: 'Приложение позволяет настраивать\n карточки под потребности каждого ребенка.',
                ),
                SizedBox(width: 40.0),
                ImageTextContainer(
                  assetImagePath: 'assets/jpg/icon1.jpg',
                  firstText: 'Реалистичные карточки',
                  secondText: 'Приложение позволяет настраивать\n карточки под потребности каждого ребенка.',
                ),
              ],
            ),
            SizedBox(height: 40),
            // Second row of ImageTextContainers
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageTextContainer(
                  assetImagePath: 'assets/jpg/icon3.jpg',
                  firstText: 'Распознавание и создание речи',
                  secondText: 'Приложение позволяет настраивать\n карточки под потребности каждого ребенка.',
                ),
                SizedBox(width: 40.0),
                ImageTextContainer(
                  assetImagePath: 'assets/jpg/icon2.jpg',
                  firstText: 'Отслеживание прогресса',
                  secondText: 'Приложение позволяет настраивать\n карточки под потребности каждого ребенка.',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ImageTextContainer extends StatelessWidget {
  final String assetImagePath;
  final String firstText;
  final String secondText;

  const ImageTextContainer({super.key, 
    required this.assetImagePath,
    required this.firstText,
    required this.secondText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0), // Optional: For rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // Shadow color
            spreadRadius: 1, // How much the shadow should spread
            blurRadius: 3, // How blurry the shadow should be
            offset: Offset(0, 3), // Shadow offset
          ),
        ],
      ),
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Image on the left
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              assetImagePath,
              width: 100,
              height: 101,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: 8.0),
          // Texts on the right
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                firstText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                secondText,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
