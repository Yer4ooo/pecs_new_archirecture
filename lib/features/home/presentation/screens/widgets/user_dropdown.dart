import 'package:flutter/material.dart';
import 'package:pecs_new_arch/features/start/presentation/start_page.dart';


class UserDropdown extends StatefulWidget {
  final String username;

  const UserDropdown({super.key, required this.username});

  @override
  State<UserDropdown> createState() => _UserDropdownState();
}

class _UserDropdownState extends State<UserDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 20.0, // Green icon
            backgroundColor: Colors.white, // Avatar radius
            child: Icon(Icons.person, size: 30, color: Colors.green),
          ),
          SizedBox(width: 10),
          Text(
            widget.username,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(97, 148, 81, 1), // Green text color
            ),
          ),
          SizedBox(width: 5),
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.arrow_drop_down,
              color:  Color.fromRGBO(97, 148, 81, 1), // Green dropdown icon
            ),
            color: Colors.white, // White background for the entire dropdown
            onSelected: (String selectedItem) {
              if (selectedItem == 'Profile Page') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SizedBox()),
                );
              }else if (selectedItem == 'Settings') {
                // Navigate to settings page
              } else if (selectedItem == 'Logout') {
               Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StartPage()),
                );
              }                                  
              // Add other actions for 'Settings' and 'Logout' here
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Profile Page',
                child: Text(
                  'Профиль',
                  style: TextStyle(
                    fontSize: 14,
                    color:  Color.fromRGBO(97, 148, 81, 1), // Green text color
                  ),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Settings',
                child: Text(
                  'Настройки',
                  style: TextStyle(
                    fontSize: 14,
                    color:  Color.fromRGBO(97, 148, 81, 1), // Green text color
                  ),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Logout',
                child: Text(
                  'Выход',
                  style: TextStyle(
                    fontSize: 14,
                    color:  Color.fromRGBO(97, 148, 81, 1), // Green text color
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}