import 'package:flutter/material.dart';
import 'package:pecs_new_arch/features/about/presentation/screens/about_us.dart';
import 'package:pecs_new_arch/features/board/presentation/screens/boards_screen.dart';
import 'package:pecs_new_arch/features/home/presentation/screens/home_screen.dart';
import 'package:pecs_new_arch/features/home/presentation/screens/widgets/user_dropdown.dart';
import 'package:pecs_new_arch/features/library/presentation/screens/categories.dart';
import 'package:pecs_new_arch/initapp.dart';

class HomeTopWidget extends StatefulWidget {
  const HomeTopWidget({super.key});

  @override
  State<HomeTopWidget> createState() => _HomeTopWidgetState();
}

class _HomeTopWidgetState extends State<HomeTopWidget> {
  String selectedItem = 'Главная';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 20, vertical: 20), // Increased padding for tablet
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Image.asset(
                  'assets/jpg/logo.jpg', // Your logo path
                  height: 150, // Adjust size for tablet
                ),
                _buildNavItem(context, 'Главная', HomeScreen()),
                _buildNavItem(context, 'Наша платформа', AboutUs()),
                _buildNavItem(context, 'О нас', AboutUs()),
                _buildNavItem(context, 'Доска', BoardsScreen()),
                _buildNavItem(
                    context,
                    'Библиотека',
                    Categories(
                    )),
                _buildNavItem(context, 'Контакты', AboutUs()),
                Expanded(
                    child: UserDropdown(
                  username: 'username',
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, String title, Widget destinationPage) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 25), // Increased spacing between items
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedItem = title; // Update the selected item
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destinationPage),
          );
        },
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: selectedItem == title
                ? FontWeight.bold
                : FontWeight.normal, // Bold if selected
            color: const Color.fromRGBO(97, 148, 81, 1), // Red if selected
            decoration: selectedItem == title
                ? TextDecoration.underline
                : TextDecoration.none, // Underline if selected
          ),
        ),
      ),
    );
  }
}
